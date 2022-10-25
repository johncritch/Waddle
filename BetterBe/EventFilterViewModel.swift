//
//  EventFilterViewModel.swift
//  Waddle
//
//  Created by John Critchlow on 10/20/22.
//

import Foundation

enum EventFilterViewModel: Int, CaseIterable {
    case events
    case replies
    case likes
    
    var title: String {
        switch self {
        case .events: return "Events"
        case .replies: return "Replies"
        case .likes: return "Likes"
        }
    }
}
