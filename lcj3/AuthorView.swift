//
//  AuthorView.swift
//  lcj3
//
//  Created by Dagg on 7/2/22.
//

import SwiftUI

struct AuthorView: View {
    var cid: String = ""
    @State var videos: [Video] = []
    @State var doNotRequest: Bool = false
    @State private var channel: Author = Author(id: "", banner: "", pfp: "", title: "")
    
    var body: some View {
        VStack {
            ZStack {
                ZStack {
                    Rectangle().foregroundColor(.black).aspectRatio(3,contentMode: .fit).layoutPriority(1)
                    AsyncImage(url: URL(string: channel.banner)) { Image in
                        Image.resizable().scaledToFill()
                    } placeholder: {
                        ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color(.systemGray)))
                    }
                }.mask {
                    Rectangle()
                }
                HStack {
                    ZStack {
                        Rectangle().foregroundColor(.clear)
                        AsyncImage(url: URL(string: channel.pfp)) { Image in
                            Image.resizable().mask {
                                Circle()
                            }
                        } placeholder: {
                            ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color(.systemGray)))
                        }
                    }.aspectRatio(contentMode: .fit).padding()
                }
            }.aspectRatio(3,contentMode: .fit).navigationTitle(channel.title).onAppear {
                if(!doNotRequest) {
                    channel = requestChannelStats(channelId: cid)
                    videos = requestChannelVideos(channelId: cid)
                    doNotRequest = true
                }
            }
            List {
                ForEach(videos) { subject in
                    ZStack {
                        NavigationLink(destination: VideoView(video:subject, isFromChannel: true)) {
                            
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
                                    //Text(subject.author).font(.caption)
                                }
                                Spacer()
                                Text("\(subject.views.Abbreviate)\n views").multilineTextAlignment(.center).font(.subheadline)
                            }.padding(.horizontal)
                            Divider().frame(height:10).overlay(.bar)
                        }
                    }
                }.listRowInsets(EdgeInsets()).listRowSeparator(.hidden)
            }.listStyle(.plain)
        }
        
    }
}

struct AuthorView_Previews: PreviewProvider {
    static var previews: some View {
        AuthorView(doNotRequest: true)
    }
}
