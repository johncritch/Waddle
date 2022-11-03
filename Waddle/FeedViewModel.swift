//
//  FeedViewModel.swift
//  Waddle
//
//  Created by John Critchlow on 11/3/22.
//

import Foundation

class FeedViewModel: ObservableObject {
    @Published var events = [Event]()
    let service = EventService()
    let userService = UserService()
    
    init() {
        fetchEvents()
    }
    
    func fetchEvents() {
        service.fetchEvents { events in
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
