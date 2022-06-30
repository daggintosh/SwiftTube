//
//  SearchView.swift
//  lcj3
//
//  Created by Dagg on 6/30/22.
//

import SwiftUI

struct SearchView: View {
    @State var searchText: String = ""
    @State var disableGo: Bool = true
    
    var body: some View {
        VStack() {
            ZStack() {
                Rectangle().foregroundColor(Color(UIColor.systemGray5))
                HStack() {
                    Image(systemName: "magnifyingglass")
                    TextField("Search ...", text: $searchText).onChange(of: searchText) { newValue in
                        if (newValue.trimmingCharacters(in: .whitespacesAndNewlines) != "") {
                            disableGo = false
                        }
                        else {
                            disableGo = true
                        }
                    }
                }.padding(.horizontal)
            }.cornerRadius(20).frame(height:40).padding()
            NavigationLink(destination: ContentView(resultsTitle: searchText, displaySearch: false, searchTerm: searchText.trimmingCharacters(in: .whitespacesAndNewlines), doNotRequest: false))
            {
                Text("Go")
            }.disabled(disableGo)
            Spacer()
        }.navigationTitle("Search YouTube")
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
