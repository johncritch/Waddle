//
//  ExploreViewModel.swift
//  Waddle
//
//  Created by John Critchlow on 11/3/22.
//

import Foundation

class ExploreViewModel: ObservableObject {
    @Published var users = [User]()
    @Published var events = [Event]()
    @Published var searchText = ""
    
    var searchableUsers: [User] {
        if searchText.isEmpty {
            return users
        } else {
            let lowercasedQuery = searchText.lowercased()
            
            return users.filter({
                $0.username.contains(lowercasedQuery) ||
                $0.first.lowercased().contains(lowercasedQuery) ||
                $0.last.lowercased().contains(lowercasedQuery) ||
                $0.fullname.lowercased().contains(lowercasedQuery)
            })
        }
    }
    
    var searchableEvents: [Event] {
        if searchText.isEmpty {
            return []
        } else {
            let lowercasedQuery = searchText.lowercased()
            
            let filteredEvents = events.filter { event in
                for tag in event.tags {
                    if tag.title.lowercased().contains(lowercasedQuery) {
                        return true
                    }
                }
                if event.title.lowercased().contains(lowercasedQuery) ||
                    event.city.lowercased().contains(lowercasedQuery) ||
                    event.caption.lowercased().contains(lowercasedQuery) {
                    return true
                } else {
                    if let eventUser = event.user {
                        if eventUser.fullname.lowercased().contains(lowercasedQuery) {
                            return true
                        }
                    }
                }
                return false
            }
            print("DEBUG: \(filteredEvents)")
            return filteredEvents
        }
    }
    
    let userService = UserService()
    let eventService = EventService()
    
    init() {
        fetchUsers()
        fetchEvents()
    }
    
    func fetchUsers() {
        userService.fetchUsers { users in
            self.users = users
        }
    }
    
    func fetchEvents() {
        eventService.fetchEvents { events in
            self.events = events
            
            for i in 0..<events.count {
                let uid = events[i].uid
                
                self.userService.fetchUser(withUid: uid) { user in
                    self.events[i].user = user
                }
            }
        }
    }
}
