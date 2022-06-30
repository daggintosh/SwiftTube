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
    //let webConfig: WKWebViewConfiguration
    //let webView: WKWebView = WKWebView(frame: .zero, configuration: webConfig)
    let target: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webConfig = WKWebViewConfiguration()
        webConfig.allowsInlineMediaPlayback = true
        webConfig.allowsPictureInPictureMediaPlayback = true
        let webView = WKWebView(frame: .zero, configuration: webConfig)
        
        webView.load(.init(url: URL(string: "https://youtube.com/embed/\(target)?playsinline=1")!))
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
}

