//
//  MainTabView.swift
//  Waddle
//
//  Created by John Critchlow on 10/20/22.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedIndex = 0
    var body: some View {
        TabView(selection: $selectedIndex) {
            FeedView()
                .onTapGesture {
                    self.selectedIndex = 0
                }
                .tabItem {
                    Label("Community", systemImage: "person.3")
                }.tag(0)
            
            ExploreView()
                .onTapGesture {
                    self.selectedIndex = 1
                }
                .tabItem {
                    Label("Explore", systemImage: "globe.americas")
                }.tag(1)
            
            MyEventsView()
                .onTapGesture {
                    self.selectedIndex = 2
                }
                .tabItem {
                    Label("My Events", systemImage: "checklist.checked")
                }.tag(2)
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
