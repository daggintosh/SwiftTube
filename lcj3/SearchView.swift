//
//  SearchView.swift
//  lcj3
//
//  Created by Dagg on 6/30/22.
//

import SwiftUI

struct SearchView: View {
    @State var searchText: String = ""
    @State private var readyToNav: Bool = false
    @FocusState private var searchFocus: Bool
    @State private var clearVisible: Bool = false
    
    var body: some View {
        ZStack {
            Rectangle().onTapGesture {
                searchFocus = false
            }.foregroundColor(Color(.systemBackground))
            VStack() {
                ZStack() {
                    Rectangle().foregroundColor(Color(UIColor.systemGray5))
                    HStack() {
                        Image(systemName: "magnifyingglass")
                        TextField("Search ...", text: $searchText).keyboardType(.webSearch).onSubmit {
                            if (searchText.trimmingCharacters(in: .whitespacesAndNewlines) != "") {
                                readyToNav = true
                            }
                        }.focused($searchFocus).onAppear {
                            searchFocus = true
                        }.onChange(of: searchText) { newValue in
                            withAnimation {
                                if(newValue != "") {
                                    clearVisible = true
                                }
                                else {
                                    clearVisible = false
                                }
                            }
                        }
                        if(clearVisible) {
                            Button {
                                searchText = ""
                            } label: {
                                Image(systemName: "xmark").foregroundColor(Color(.systemGray))
                            }
                        }
                    }.padding(.horizontal)
                }.cornerRadius(20).frame(height:40).padding()
                NavigationLink(destination: ContentView(resultsTitle: searchText, displaySearch: false, searchTerm: searchText.trimmingCharacters(in: .whitespacesAndNewlines), doNotRequest: false), isActive: $readyToNav) {}
                Spacer()
            }.navigationTitle("Search YouTube")
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
