//
//  VideoView.swift
//  lcj3
//
//  Created by Dagg on 6/29/22.
//

import SwiftUI

struct VideoView: View {
    
    var video: Video = Video(thumbnail: "", title: "", description: "", views: "", author: "", id: "", publishDate: Date(), likes: "", channelId: "")
    var isFromChannel: Bool?
    
    var body: some View {
        VStack() {
            WebView(target: video.id).aspectRatio(16/9, contentMode: .fit)
            ScrollView() {
                HStack() {
                    VStack(alignment: .leading) {
                        Text(video.title)
                        Text("Published \(video.publishDate.formatted(date: .abbreviated, time: .omitted))").font(.caption)
                        HStack() {
                            Text("\(video.views.FormatCool) views").font(.caption)
                            Spacer()
                            Text("\(video.likes.FormatCool) likes").font(.caption)
                        }
                    }
                    Spacer()
                }
                Divider()
                if(!(isFromChannel ?? false)) {
                    NavigationLink {
                        AuthorView(cid: video.channelId)
                    } label: {
                        HStack() {
                            Text("\(video.author)")
                            Image(systemName: "chevron.right")
                            Spacer()
                        }
                    }.padding(.vertical, 1)
                    Divider()
                }
                NavigationLink {
                    ContentView(resultsTitle: "Related to \(video.author)", displaySearch: false, searchTerm: video.id, searchRelated: true)
                } label: {
                    Text("Related Videos")
                    Image(systemName: "chevron.right")
                    Spacer()
                    
                }.padding(.vertical, 1)
                Divider()
                Text(.init(video.description.FixLinks))
            }.padding(.horizontal)
        }.toolbar {
            NavigationLink("Comments") {
                CommentView(title: video.title, videoId: video.id)
            }
        }
    }
}

struct VideoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            VideoView()
        }
    }
}
