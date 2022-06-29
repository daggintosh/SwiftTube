//
//  WebView.swift
//  lcj3
//
//  Created by Dagg on 6/29/22.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    typealias UIViewType = WKWebView
    let webView: WKWebView = WKWebView()
    let target: String
    
    func makeUIView(context: Context) -> WKWebView {
        webView.configuration.allowsInlineMediaPlayback = true
        webView.configuration.allowsPictureInPictureMediaPlayback = true
        webView.load(.init(url: URL(string: "https://youtube.com/embed/\(target)?autoplay=1&modestbranding=1&playsinline=1")!))
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
}

