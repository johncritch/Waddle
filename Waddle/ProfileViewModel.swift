//
//  ProfileViewModel.swift
//  Waddle
//
//  Created by John Critchlow on 11/3/22.
//

import Foundation

class ProfileViewModel: ObservableObject {
    @Published var events = [Event]()
    @Published var joinedEvents = [Event]()
    
    private let service = EventService()
    private let userService = UserService()
    let user: User
    
    init(user: User) {
        self.user = user
        self.fetchUserEvents()
        self.fetchJoinedEvents()
    }
    
    var actionButtonTitle: String {
        return user.isCurrentUser ? "Edit Profile" : "Follow"
    }
    
    func events(forFilter filter: EventFilterViewModel) -> [Event] {
        switch filter {
        case .events:
            return events
        case .replies:
            return events
        case .joined:
//            print("DEBUG: joined events: \(joinedEvents)")
            return joinedEvents
        }
    }
    
    func fetchUserEvents() {
        guard let uid = user.id else { return }
        service.fetchEvents(forUid: uid) { events in
            self.events = events
            
            for i in 0..<events.count {
                self.events[i].user = self.user
            }
        }
    }
    
    func fetchJoinedEvents() {
        guard let uid = user.id else { return }
        
        service.fetchJoinedEvents(forUid: uid) { events in
            self.joinedEvents = events
            print("DEBUG: (2) Joined events\(self.joinedEvents)")
            
            for i in 0..<events.count {
                let uid = events[i].uid
                
                self.userService.fetchUser(withUid: uid) { user in
                    self.joinedEvents[i].user = user
                }
            }
            return
        }
        self.joinedEvents = []
    }
}
