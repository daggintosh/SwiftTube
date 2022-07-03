//
//  VideoStructure.swift
//  lcj3
//
//  Created by Dagg on 7/2/22.
//

import Foundation

struct Video: Identifiable {
    let thumbnail: String
    let title: String
    let description: String
    let views: String
    let author: String
    let id: String
    let publishDate: Date
    let likes: String
    let channelId: String
}

struct Author: Identifiable {
    let id: String
    
    let banner: String
    let pfp: String
    let title: String
}
