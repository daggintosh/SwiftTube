//
//  SearchLogic.swift
//  lcj3
//
//  Created by Dagg on 6/30/22.
//
//

import Foundation

struct searchId: Decodable {
    let id: String
    
    enum ItemKeys: String, CodingKey {
        case id
    }
    
    enum IdKeys: String, CodingKey {
        case videoId
    }
    
    init(from decoder: Decoder) throws {
        let itemContainer = try decoder.container(keyedBy: ItemKeys.self)
        let idContainer = try itemContainer.nestedContainer(keyedBy: IdKeys.self, forKey: .id)
        self.id = try idContainer.decode(String.self, forKey: .videoId)
    }
}

struct videoDetails: Decodable {
    let viewCount: String
    let id: String
    let description: String
    let title: String
    let channelTitle: String
    let publishedAt: Date
    let likeCount: String
    
    enum ItemKeys: String, CodingKey {
        case id, statistics, snippet
    }
    
    enum StatisticsKeys: String, CodingKey {
        case viewCount, likeCount
    }
    
    enum SnippetKeys: String, CodingKey {
        case description, title, channelTitle, publishedAt
    }
    
    init(from decoder: Decoder) throws {
        let itemContainer = try decoder.container(keyedBy: ItemKeys.self)
        
        let statContainer = try itemContainer.nestedContainer(keyedBy: StatisticsKeys.self, forKey: .statistics)
        let snippetContainer = try itemContainer.nestedContainer(keyedBy: SnippetKeys.self, forKey: .snippet)
        self.viewCount = try statContainer.decodeIfPresent(String.self, forKey: .viewCount) ?? ""
        self.id = try itemContainer.decode(String.self, forKey: .id)
        self.description = try snippetContainer.decode(String.self, forKey: .description)
        self.title = try snippetContainer.decode(String.self, forKey: .title)
        self.channelTitle = try snippetContainer.decode(String.self, forKey: .channelTitle)
        self.publishedAt = try snippetContainer.decode(Date.self, forKey: .publishedAt)
        self.likeCount = try statContainer.decodeIfPresent(String.self, forKey: .likeCount) ?? ""
    }
}

struct details: Decodable {
    let items: [videoDetails]
}

struct items: Decodable {
    let items: [searchId]
}

struct apiKey: Decodable {
    let apiKey: String
}

func getAPIKey() -> String {
    let keyURL = Bundle.main.url(forResource: "APIKey", withExtension: "plist")!
    let data = try! Data(contentsOf: keyURL)
    let result = try! PropertyListDecoder().decode(apiKey.self, from: data)
    return result.apiKey
}

func searchYouTube(phrase: String) -> [Video] {
    let apiKey = getAPIKey()
    
    var cvid: [Video] = [
        
    ]
    
    let encodedPhrase: String = phrase.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    
    var decoded: items?
    
    let url = URL(string: "https://youtube.googleapis.com/youtube/v3/search?part=id&maxResults=10&q=\(encodedPhrase)&type=video&key=\(apiKey)")!

    let sem = DispatchSemaphore.init(value: 0)
    let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
        defer { sem.signal() }
        guard let data = data else { return }
        
        decoded = try? JSONDecoder().decode(items.self, from: data)
    }
    
    
    task.resume()
    sem.wait()
    
    var detailsDecoded: details?
    
    var ids: String = ""
    decoded?.items.forEach({ item in
        ids.append("\(item.id),")
    })
    
    let viewURL = URL(string: "https://youtube.googleapis.com/youtube/v3/videos?part=statistics,snippet&id=\(ids)&key=\(apiKey)")!
    
    let sem2 = DispatchSemaphore.init(value: 0)
    
    let viewTask = URLSession.shared.dataTask(with: viewURL) { (newdata, newresponse, newerror) in
        defer {sem2.signal()}
        guard let newdata = newdata else { return }
        
        let stdecoder = JSONDecoder()
        stdecoder.dateDecodingStrategy = .iso8601
        
        detailsDecoded = try! stdecoder.decode(details.self, from: newdata)
    }
    
    viewTask.resume()
    sem2.wait()
    
    detailsDecoded?.items.forEach({ item in
        cvid.append(Video(thumbnail: "https://i.ytimg.com/vi/\(item.id)/hq720.jpg", title: item.title, description: item.description, views: item.viewCount, author: item.channelTitle, id: item.id, publishDate: item.publishedAt, likes: item.likeCount))
    })
    
    print("The API has been called")
    return cvid
}

func requestTrending() -> [Video] {
    var tVid: [Video] = [
        
    ]
    let apiKey = getAPIKey()
    
    var decoded: details?

    let viewURL = URL(string: "https://youtube.googleapis.com/youtube/v3/videos?part=snippet%2Cstatistics&chart=mostPopular&maxResults=10&key=\(apiKey)")!
    
    let sem = DispatchSemaphore.init(value: 0)
    
    let viewTask = URLSession.shared.dataTask(with: viewURL) { (data, resp, err) in
        defer {sem.signal()}
        guard let data = data else { return }
        
        let stdecoder = JSONDecoder()
        stdecoder.dateDecodingStrategy = .iso8601
        
        decoded = try? stdecoder.decode(details.self, from: data)
    }
    
    viewTask.resume()
    sem.wait()
    
    decoded?.items.forEach({ snip in
        tVid.append(Video(thumbnail: "https://i.ytimg.com/vi/\(snip.id)/hq720.jpg", title: snip.title, description: snip.description, views: snip.viewCount, author: snip.channelTitle, id: snip.id, publishDate: snip.publishedAt, likes: snip.likeCount))
    })
    
    return tVid
}
