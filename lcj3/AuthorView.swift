//
//  AuthorView.swift
//  lcj3
//
//  Created by Dagg on 7/2/22.
//

import SwiftUI

struct AuthorView: View {
    var cid: String = ""
    @State var doNotRequest: Bool = false
    @State private var channel: Author = Author(id: "", banner: "https://yt3.ggpht.com/GMwSJkuPHgb21JRY1q5MYZzbszlv5X1aYexjt7r1AhzFl5_qqTejgVlVnbUf8KDsbYsNWSQj", pfp: "", title: "")
    
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
                }
            }
            VStack {
                HStack {
                    Text("Uploads").font(.title)
                    Spacer()
                }
                List {
                    
                }
            }.padding(.horizontal)
        }
    }
}

struct AuthorView_Previews: PreviewProvider {
    static var previews: some View {
        AuthorView(doNotRequest: true)
    }
}
