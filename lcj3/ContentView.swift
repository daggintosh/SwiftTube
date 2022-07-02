//
//  ContentView.swift
//  lcj3
//
//  Created by Dagg on 6/28/22.
//

import SwiftUI

struct ContentView: View {
    var resultsTitle: String = ""
    var displaySearch: Bool = true
    var searchTerm: String = ""
    // Requests to the API should be made only when necessary
    @State var doNotRequest: Bool = false
    
    @State private var videoArr: [Video] = [
        
    ]
    
    var body: some View {
        if(displaySearch == true) {
            TabView {
                NavigationView {
                    restOfView.navigationTitle("Trending").navigationBarTitleDisplayMode(.inline).listStyle(.plain).onAppear() {
                        if !doNotRequest {
                            let ret = requestTrending()
                            videoArr = ret
                            doNotRequest = true
                        }
                    }
                }.tabItem {
                    Image(systemName: "star")
                    Text("Trending")
                }
                NavigationView {
                    SearchView()
                }.tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
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
                    NavigationLink(destination: VideoView(video:subject)) {
                        
                    }
                    VStack() {
                        ZStack {
                            Rectangle().foregroundColor(.black).aspectRatio(16/9, contentMode: .fill)
                            AsyncImage(url: URL(string: subject.thumbnail)) { Image in
                                Image.resizable()
                            } placeholder: {
                                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color(.systemGray)))
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
        ContentView(doNotRequest: true)
    }
}
