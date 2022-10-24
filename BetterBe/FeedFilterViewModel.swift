//
//  FeedFilterViewModel.swift
//  BetterBe
//
//  Created by John Critchlow on 10/24/22.
//

import Foundation

enum FeedFilterViewModel: Int, CaseIterable {
    case friends
    case community
    
    var title: String {
        switch self {
        case .friends: return "Friends"
        case .community: return "Community"
        }
    }
}
