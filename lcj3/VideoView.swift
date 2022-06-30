//
//  VideoView.swift
//  lcj3
//
//  Created by Dagg on 6/29/22.
//

import SwiftUI

struct VideoView: View {
    
    var title: String = "None"
    var author: String = "None"
    var description: String = "No description"
    var views: String = "301"
    var videoId: String = "9iNxhEn-9D4"
    
    var body: some View {
        VStack() {
            WebView(target: videoId).aspectRatio(16/9, contentMode: .fit)
            HStack() {
                VStack(alignment: .leading) {
                    Text(title)
                    Text(author).font(.footnote)
                    Text("\(views) views").font(.caption)
                }
                Spacer()
            }.padding(.horizontal)
            Divider().padding(.horizontal)
            ScrollView() {
                Text(description)
            }.padding(.horizontal)
            Divider().padding(.horizontal)
            Spacer()
        }.navigationTitle(title)
    }
}

struct VideoView_Previews: PreviewProvider {
    static var previews: some View {
        VideoView()
    }
}
