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
    let target: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webConfig = WKWebViewConfiguration()
        webConfig.allowsInlineMediaPlayback = true
        webConfig.allowsPictureInPictureMediaPlayback = true
        let webView = WKWebView(frame: .zero, configuration: webConfig)
        var urlRequest = URLRequest(url: URL(string: "https://youtube.com/embed/\(target)?playsinline=1&color=white")!)
        urlRequest.addValue("https://www.youtube.com/", forHTTPHeaderField: "Referer")
        urlRequest.addValue(Bundle.main.bundleIdentifier!, forHTTPHeaderField: "X-Ios-Bundle-Identifier")
        webView.load(urlRequest)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
}

