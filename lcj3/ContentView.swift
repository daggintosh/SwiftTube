//
//  ContentView.swift
//  lcj3
//
//  Created by Dagg on 6/28/22.
//

import SwiftUI

struct ContentView: View {
    struct Video: Identifiable {
        let thumbnail: Image?
        let title: String
        let description: String
        let views: String
        let author: String
        let id: String
    }
    
    var videoArr: [Video] = [
        Video(thumbnail: Image(systemName: "circle"), title: "Rick Astley - Never Gonna Give You Up (Official Music Video)", description: "9iNxhEn", views: "1240134028", author: "Rick Astley", id: "9iNxhEn-9D4"),
        Video(thumbnail: Image(systemName: "square"), title: "Title2", description: "Description2", views: "2934", author: "Author", id: "Gc3tqnhmf5U"),
        Video(thumbnail: Image(systemName: "circle.fill"), title: "Title3", description: "Description", views: "298", author: "Author", id: "545"),
        Video(thumbnail: Image(systemName: "triangle"), title: "Title4", description: "Description", views: "923199999999", author: "Author", id: "546")
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(videoArr) { subject in
                    NavigationLink(destination: VideoView(title: subject.title, author: subject.author, description: subject.description, views: subject.views.FormatCool,videoId: subject.id)) {
                        VStack() {
                            subject.thumbnail?.resizable().aspectRatio(16/9, contentMode: .fit)
                            HStack() {
                                VStack(alignment: .leading) {
                                    Text(subject.title).font(.callout)
                                    Text(subject.author).font(.caption)
                                }
                                Spacer()
                                Text("\(subject.views.Abbreviate)\n views").multilineTextAlignment(.center).font(.subheadline)
                            }
                            
                        }
                    }
                }
            }.navigationTitle("LCJ3 r2").navigationBarTitleDisplayMode(.inline)
            
        }.navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
