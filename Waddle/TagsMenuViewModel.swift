//
//  TagsMenuViewModel.swift
//  Waddle
//
//  Created by John Critchlow on 11/8/22.
//

import Foundation

class TagsMenuViewModel: ObservableObject {
    @Published var tagList = [
        Tag(id: 0, title: "Adventure"),
        Tag(id: 1, title: "Sports"),
        Tag(id: 2, title: "Date"),
        Tag(id: 3, title: "Hike"),
        Tag(id: 4, title: "Basketball"),
        Tag(id: 5, title: "Football"),
        Tag(id: 6, title: "Pickleball"),
        Tag(id: 7, title: "Board Games"),
        Tag(id: 8, title: "Party"),
        Tag(id: 9, title: "Party Games"),
        Tag(id: 10, title: "Food"),
        Tag(id: 11, title: "Bonfire"),
        Tag(id: 12, title: "Snacks"),
        Tag(id: 13, title: "Camping"),
        Tag(id: 14, title: "Lake"),
        Tag(id: 15, title: "River"),
        Tag(id: 16, title: "Boating"),
        Tag(id: 17, title: "Outdoors"),
        Tag(id: 18, title: "Indoors"),
        Tag(id: 19, title: "Small Group"),
        Tag(id: 20, title: "Big Group"),
        Tag(id: 21, title: "Girls"),
        Tag(id: 22, title: "Guys"),
        Tag(id: 23, title: "Swimming"),
        Tag(id: 24, title: "Water"),
        Tag(id: 25, title: "Winter-Sports"),
        Tag(id: 26, title: "Running"),
        Tag(id: 27, title: "Movie"),
        Tag(id: 28, title: "Watch Party")
    ]
    @Published var searchText = ""
    
    var popularTags: [Tag] {
        Array(tagList.prefix(5))
    }
    
    var searchableTags: [Tag] {
        if searchText.isEmpty {
            return tagList
        } else {
            let lowercasedQuery = searchText.lowercased()
            
            return tagList.filter({
                $0.title.lowercased().contains(lowercasedQuery)
            })
        }
    }
}

struct Tag: Identifiable, Equatable {
    var id: Int
    var title: String
}
