//
//  ContentView.swift
//  lcj3
//
//  Created by Dagg on 6/28/22.
//

import SwiftUI

struct ContentView: View {
    struct Video: Identifiable {
        let thumbnail: String
        let title: String
        let description: String
        let views: String
        let author: String
        let id: String
    }
    
    var resultsTitle: String = "Home"
    var displaySearch: Bool = true
    var searchTerm: String = ""
    // Requests to the API should be made only when necessary
    @State var doNotRequest: Bool = true
    
    @State var videoArr: [Video] = [
        Video(thumbnail: "https://i3.ytimg.com/vi/9iNxhEn-9D4/maxresdefault.jpg", title: "Rick Astley - Never Gonna Give You Up (Official Music Video)", description: "9iNxhEn", views: "1240134028", author: "Rick Astley", id: "9iNxhEn-9D4"),
        Video(thumbnail: "https://i3.ytimg.com/vi/Gc3tqnhmf5U/maxresdefault.jpg", title: "Oblivion (Placeholder)", description: "By theFatRat", views: "10000000", author: "TheFatRat", id: "Gc3tqnhmf5U"),
        Video(thumbnail: "https://i3.ytimg.com/vi/-WpnPSChVRQ/maxresdefault.jpg", title: "[Full Song/Official Lyrics] Devil Trigger - Nero's battle theme from Devil May Cry 5", description: "Devil Trigger - Nero's Battle Theme from Devil May Cry 5 by Casey Edwards feat. Ali Edwards and Cliff Lloret", views: "56591174", author: "R H", id: "-WpnPSChVRQ"),
        Video(thumbnail: "https://i3.ytimg.com/vi/RjLWGyx4zoA/hqdefault.jpg", title: "Persona 5-Battle Victory Theme(Extended)", description: "This was so d*mn catchy I couldn't help myself. I do not own the \"Persona\" series in any form or fashion. I do not own the pictures used in this video, nor do I own the original soundtrack played in this video. All rights reserved to Atlus.", views: "864098", author: "Hey Arnold", id: "RjLWGyx4zoA")
    ]
    
    var body: some View {
        if(displaySearch == true) {
            NavigationView {
                restOfView.navigationTitle(resultsTitle).navigationBarTitleDisplayMode(.inline).listStyle(.plain).toolbar {
                    NavigationLink {
                        SearchView()
                    } label: {
                        if displaySearch {
                            Image(systemName: "magnifyingglass")
                        }
                    }
                }
            }
        }
        else {
            restOfView.navigationTitle(resultsTitle).navigationBarTitleDisplayMode(.inline).listStyle(.plain).onAppear {
                if !doNotRequest {
                    let ret = searchYouTube(phrase: searchTerm)
                    videoArr = ret
                    doNotRequest = true
                }
            }
        }
    }
    
    var restOfView: some View {
        List {
            ForEach(videoArr) { subject in
                ZStack {
                    NavigationLink(destination: VideoView(title: subject.title, author: subject.author, description: subject.description, views: subject.views.FormatCool,videoId: subject.id)) {
                        
                    }
                    VStack() {
                        ZStack {
                            Rectangle().foregroundColor(.black).aspectRatio(16/9, contentMode: .fill)
                            AsyncImage(url: URL(string: subject.thumbnail)) { Image in
                                Image.resizable()
                            } placeholder: {
                                ProgressView()
                            }.aspectRatio(16/9, contentMode: .fill)
                            
                        }
                        HStack() {
                            VStack(alignment: .leading) {
                                Text(subject.title).font(.callout)
                                Text(subject.author).font(.caption)
                            }
                            Spacer()
                            Text("\(subject.views.Abbreviate)\n views").multilineTextAlignment(.center).font(.subheadline)
                        }.padding(.horizontal)
                        Divider().frame(height:10).overlay(.bar)
                    }
                }.listRowInsets(EdgeInsets()).listRowSeparator(.hidden)
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
