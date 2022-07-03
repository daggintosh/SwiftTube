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
    let channelId: String
    
    enum ItemKeys: String, CodingKey {
        case id, statistics, snippet
    }
    
    enum StatisticsKeys: String, CodingKey {
        case viewCount, likeCount
    }
    
    enum SnippetKeys: String, CodingKey {
        case description, title, channelTitle, publishedAt, channelId
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
        self.channelId = try snippetContainer.decode(String.self, forKey: .channelId)
    }
}

struct channelDetails: Decodable {
    let id: String
    let title: String
    let profilePicture: String
    let profileBanner: String
    
    enum ItemKeys: String, CodingKey {
        case snippet, brandingSettings, id
    }
    
    enum SnippetKeys: String, CodingKey {
        case thumbnails
    }
    
    enum BrandingKeys: String, CodingKey {
        case channel, image
    }
    
    enum PFPKeys: String, CodingKey {
        case high
    }
    enum HPFKeys: String, CodingKey {
        case url
    }
    
    enum ChannelKeys: String, CodingKey {
        case title, description
    }
    
    enum BannerKeys: String, CodingKey {
        case bannerExternalUrl
    }
    
    init(from decoder: Decoder) throws {
        let items = try decoder.container(keyedBy: ItemKeys.self)
        let snippet = try items.nestedContainer(keyedBy: SnippetKeys.self, forKey: .snippet)
        let branding = try items.nestedContainer(keyedBy: BrandingKeys.self, forKey: .brandingSettings)
        let pfp = try snippet.nestedContainer(keyedBy: PFPKeys.self, forKey: .thumbnails)
        let high = try pfp.nestedContainer(keyedBy: HPFKeys.self, forKey: .high)
        let banner = try branding.nestedContainer(keyedBy: BannerKeys.self, forKey: .image)
        let details = try branding.nestedContainer(keyedBy: ChannelKeys.self, forKey: .channel)
        self.profilePicture = try high.decode(String.self, forKey: .url)
        self.profileBanner = try banner.decode(String.self, forKey: .bannerExternalUrl)
        self.title = try details.decode(String.self, forKey: .title)
        self.id = try items.decode(String.self, forKey: .id)
    }
}

struct details: Decodable {
    let items: [videoDetails]
}

struct items: Decodable {
    let items: [searchId]
}

struct channels: Decodable {
    let items: [channelDetails]
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
    
    getDetails(items: decoded!).items.forEach({ item in
        cvid.append(Video(thumbnail: "https://i.ytimg.com/vi/\(item.id)/hq720.jpg", title: item.title, description: item.description, views: item.viewCount, author: item.channelTitle, id: item.id, publishDate: item.publishedAt, likes: item.likeCount, channelId: item.channelId))
    })
    
    print("The API has been called")
    return cvid
}

func getDetails(items: items) -> details {
    let apiKey = getAPIKey()
    
    var detailsDecoded: details?
    
    var ids: String = ""
    items.items.forEach({ item in
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
    
    return detailsDecoded!
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
        tVid.append(Video(thumbnail: "https://i.ytimg.com/vi/\(snip.id)/hq720.jpg", title: snip.title, description: snip.description, views: snip.viewCount, author: snip.channelTitle, id: snip.id, publishDate: snip.publishedAt, likes: snip.likeCount, channelId: snip.channelId))
    })
    
    print("The API has been called")
    return tVid
}

func requestRelated(videoId: String) -> [Video] {
    var rVid: [Video] = [
    
    ]
    let apiKey = getAPIKey()
    
    var decoded: items?
    
    let url = URL(string: "https://youtube.googleapis.com/youtube/v3/search?part=id&maxResults=10&relatedToVideoId=\(videoId)&type=video&key=\(apiKey)")!

    let sem = DispatchSemaphore.init(value: 0)
    let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
        defer { sem.signal() }
        guard let data = data else { return }
        
        decoded = try? JSONDecoder().decode(items.self, from: data)
    }
    
    task.resume()
    sem.wait()
    
    getDetails(items: decoded!).items.forEach({ item in
        rVid.append(Video(thumbnail: "https://i.ytimg.com/vi/\(item.id)/hq720.jpg", title: item.title, description: item.description, views: item.viewCount, author: item.channelTitle, id: item.id, publishDate: item.publishedAt, likes: item.likeCount, channelId: item.channelId))
    })
    return rVid
}

func requestChannelStats(channelId: String) -> Author {
    let apiKey = getAPIKey()
    
    var decoded: channels?
    
    let url = URL(string: "https://youtube.googleapis.com/youtube/v3/channels?part=snippet%2C%20brandingSettings&id=\(channelId)&key=\(apiKey)")!
    
    let sem = DispatchSemaphore.init(value: 0)
    let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
        defer { sem.signal() }
        guard let data = data else { return }
        
        decoded = try? JSONDecoder().decode(channels.self, from: data)
    }
    
    task.resume()
    sem.wait()
    
    var author: Author?
    
    decoded?.items.forEach({ details in
        author = Author(id: details.id, banner: details.profileBanner, pfp: details.profilePicture, title: details.title)
    })
    
    return author ?? Author(id: "", banner: "", pfp: "", title: "")
}
