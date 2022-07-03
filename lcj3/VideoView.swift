//
//  VideoView.swift
//  lcj3
//
//  Created by Dagg on 6/29/22.
//

import SwiftUI

struct VideoView: View {
    
    var video: Video = Video(thumbnail: "", title: "None", description: "None", views: "", author: "None", id: "9iNxhEn-9D4", publishDate: Date(), likes: "")
    
    var body: some View {
        VStack() {
            WebView(target: video.id).aspectRatio(16/9, contentMode: .fit)
            ScrollView() {
                HStack() {
                    VStack(alignment: .leading) {
                        Text(video.title)
                        Text(video.author).font(.footnote)
                        HStack() {
                            Text("\(video.publishDate.formatted(date: .abbreviated, time: .omitted))").font(.caption)
                        }
                        HStack() {
                            Text("\(video.views.FormatCool) views").font(.caption)
                            Spacer()
                            Text("\(video.likes.FormatCool) likes").font(.caption)
                        }
                    }
                    Spacer()
                }
                Divider()
                Text(video.description)
            }.padding(.horizontal)
        }.toolbar {
            NavigationLink("Related") {
                
            }
        }
    }
}

struct VideoView_Previews: PreviewProvider {
    static var previews: some View {
        VideoView()
    }
}
