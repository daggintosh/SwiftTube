//
//  ContentView.swift
//  lcj3
//
//  Created by Dagg on 6/28/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: ContentView()) {
                    VStack() {
                        Image(systemName: "ellipsis").resizable().aspectRatio(16/9, contentMode: .fit)
                        HStack() {
                            VStack(alignment: .leading) {
                                Text("Hello, world this is a long title, a very long title").font(.callout)
                                Text("Long Name of a Creator on the Platform").font(.caption)
                            }
                            Spacer()
                            Text("100B\n views").multilineTextAlignment(.center).font(.subheadline)
                        }
                        
                    }
                }
                NavigationLink(destination: ContentView()) {
                    VStack() {
                        Image(systemName: "ellipsis").resizable().aspectRatio(16/9, contentMode: .fit)
                        HStack() {
                            VStack(alignment: .leading) {
                                Text("Sensible Title Numer 4029").font(.callout)
                                Text("Fontoso Creator 39").font(.caption)
                            }
                            Spacer()
                            Text("493K\n views").multilineTextAlignment(.center).font(.subheadline)
                        }
                        
                    }
                }
            }.navigationTitle("Fontoso").navigationBarTitleDisplayMode(.inline)
            
        }.navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
