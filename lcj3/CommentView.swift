//
//  CommentView.swift
//  lcj3
//
//  Created by Dagg on 7/2/22.
//

import SwiftUI

struct CommentView: View {
    var title: String = ""
    var videoId: String = ""
    @State var doNotRequest: Bool = false
    @State var comments: [Comment] = [
        
    ]
    
    var body: some View {
        List {
            restOfCView
        }.listStyle(.plain).navigationTitle(title).navigationBarTitleDisplayMode(.inline).onAppear {
            if(!doNotRequest) {
                comments = requestComments(videoId: videoId)
                doNotRequest = true
            }
        }
    }
    
    var restOfCView: some View {
        ForEach(comments) { comment in
            VStack {
                HStack {
                    VStack {
                        ZStack {
                            Circle().frame(width: 48, height: 48)
                            AsyncImage(url: URL(string: comment.pfp)!) { Image in
                                Image
                            } placeholder: {
                                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: Color(.systemGray)))
                            }.mask {
                                Circle()
                            }
                        }
                        Spacer()
                    }
                    VStack {
                        HStack {
                            Text(comment.author).fontWeight(.bold)
                            Spacer()
                            Text(comment.publishDate.formatted(date: .abbreviated, time: .omitted))
                        }
                        HStack {
                            Text(comment.comment)
                            Spacer()
                        }
                    }.padding(.leading)
                }.padding()
                if(comment.replyCount > 0) {
                    NavigationLink {
                        let replies = processReplies(comments: comment.replies)
                        CommentView(title: "Replies to \(comment.author)", doNotRequest: true, comments: replies)
                    } label: {
                        Text("\(comment.replyCount) replies")
                    }.padding(.horizontal)
                }
                Divider().frame(height:10).overlay(.bar)
            }.listRowSeparator(.hidden).listRowInsets(EdgeInsets())
        }
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CommentView(doNotRequest: true)
        }
    }
}
