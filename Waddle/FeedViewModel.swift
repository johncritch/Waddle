//
//  FeedViewModel.swift
//  Waddle
//
//  Created by John Critchlow on 11/3/22.
//

import Foundation
import Firebase

class FeedViewModel: ObservableObject {
    @Published var events = [Event]()
    let service = EventService()
    let userService = UserService()
    @Published var followingEvents = [Event]()
    var following = [User]()
    
    init() {
        fetchEvents()
        fetchFollowingEvents()
    }
    
    func events(forFilter filter: FeedFilterViewModel) -> [Event] {
        switch filter {
        case .friends:
            return followingEvents
        case .community:
            return events
        }
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
    
    func fetchFollowingEvents() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        service.fetchFollowingEvents(forUid: uid) { events in
            self.followingEvents = events
            
            for i in 0..<events.count {
                let uid = events[i].uid
                
                self.userService.fetchUser(withUid: uid) { user in
                    self.followingEvents[i].user = user
                }
            }
//            print("DEBUG: Following Events: \(self.followingEvents)")
        }
    }
}
