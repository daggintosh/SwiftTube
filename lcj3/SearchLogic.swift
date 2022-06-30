//
//  SearchLogic.swift
//  lcj3
//
//  Created by Dagg on 6/30/22.
//
// https://youtube.googleapis.com/youtube/v3/search?part=snippet&maxResults=10&q=Never%20gonna%20give%20you%20up&type=video&videoEmbeddable=true&videoSyndicated=true&key=[YOUR_API_KEY]

import Foundation

struct resultItems: Codable {
    let id: String
    let title: String
    let description: String
    let channelTitle: String
    let thumbnail: String
    
    enum ItemKeys: String, CodingKey {
        case id, snippet
    }
    
    enum SnippetKeys: String, CodingKey {
        case title, description, channelTitle, thumbnails
    }
    
    enum IdKeys: String, CodingKey {
        case videoId
    }
    
    enum ThumnailKeys: String, CodingKey {
        case high
    }
    
    enum HighKeys: String, CodingKey {
        case url
    }
    
    init(from decoder: Decoder) throws {
        //let outerContainer = try decoder.container(keyedBy: OuterKeys.self)
        
        let itemContainer = try decoder.container(keyedBy: ItemKeys.self)
        
        let snippetContainer = try itemContainer.nestedContainer(keyedBy: SnippetKeys.self, forKey: .snippet)
        let idContainer = try itemContainer.nestedContainer(keyedBy: IdKeys.self, forKey: .id)
        let thumbnailContainer = try snippetContainer.nestedContainer(keyedBy: ThumnailKeys.self, forKey: .thumbnails)
        let highContainer = try thumbnailContainer.nestedContainer(keyedBy: HighKeys.self, forKey: .high)
        
        self.id = try idContainer.decode(String.self, forKey: .videoId)
        self.title = try snippetContainer.decode(String.self, forKey: .title)
        self.description = try snippetContainer.decode(String.self, forKey: .description)
        self.channelTitle = try snippetContainer.decode(String.self, forKey: .channelTitle)
        self.thumbnail = try highContainer.decode(String.self, forKey: .url)
    }
}

struct statRaw: Codable {
    let viewCount: String
    let id: String
    let description: String
    
    enum ItemKeys: String, CodingKey {
        case id, statistics, snippet
    }
    
    enum StatisticsKeys: String, CodingKey {
        case viewCount
    }
    
    enum SnippetKeys: String, CodingKey {
        case description
    }
    
    init(from decoder: Decoder) throws {
        let itemContainer = try decoder.container(keyedBy: ItemKeys.self)
        
        let statContainer = try itemContainer.nestedContainer(keyedBy: StatisticsKeys.self, forKey: .statistics)
        let snippetContainer = try itemContainer.nestedContainer(keyedBy: SnippetKeys.self, forKey: .snippet)
        self.viewCount = try statContainer.decode(String.self, forKey: .viewCount)
        self.id = try itemContainer.decode(String.self, forKey: .id)
        self.description = try snippetContainer.decode(String.self, forKey: .description)
    }
}

struct stats: Codable {
    let items: [statRaw]
}

struct items: Codable {
    let items: [resultItems]
}

struct apiKey: Decodable {
    let apiKey: String
}

func searchYouTube(phrase: String) -> [ContentView.Video] {
    let keyURL = Bundle.main.url(forResource: "APIKey", withExtension: "plist")!
    let data = try! Data(contentsOf: keyURL)
    let result = try! PropertyListDecoder().decode(apiKey.self, from: data)
    let apiKey = result.apiKey
    
    var cvid: [ContentView.Video] = [
        
    ]
    
    let encodedPhrase: String = phrase.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    
    var decoded: items?
    
    let url = URL(string: "https://youtube.googleapis.com/youtube/v3/search?part=snippet&maxResults=10&q=\(encodedPhrase)&type=video&videoEmbeddable=true&videoSyndicated=true&key=\(apiKey)")!

    let sem = DispatchSemaphore.init(value: 0)
    let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
        defer { sem.signal() }
        guard let data = data else { return }
        
        decoded = try! JSONDecoder().decode(items.self, from: data)
    }
    
    
    task.resume()
    sem.wait()
    
    var viewDecoded: stats?
    var ids: String = ""
    decoded?.items.forEach({ item in
        ids.append("\(item.id),")
    })
    let viewURL = URL(string: "https://youtube.googleapis.com/youtube/v3/videos?part=statistics,snippet&id=\(ids)&key=\(apiKey)")!
    let sem2 = DispatchSemaphore.init(value: 0)
    let viewTask = URLSession.shared.dataTask(with: viewURL) { (newdata, newresponse, newerror) in
        defer {sem2.signal()}
        guard let newdata = newdata else { return }
        
        viewDecoded = try! JSONDecoder().decode(stats.self, from: newdata)
        print(newdata)
    }
    
    viewTask.resume()
    sem2.wait()
    
    for (index, item) in decoded!.items.enumerated() {
        cvid.append(ContentView.Video(thumbnail: "https://i.ytimg.com/vi/\(item.id)/hq720.jpg", title: item.title.removingPercentEncoding!, description: viewDecoded?.items[index].description ?? "This video does not have a description (or I did something wrong)", views: viewDecoded?.items[index].viewCount ?? "301", author: item.channelTitle, id: item.id))
    }
    
    print("The API has been called")
    return cvid
}

func requestViewCount() {
    
}
