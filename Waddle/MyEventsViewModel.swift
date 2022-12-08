//
//  MyEventsViewModel.swift
//  Waddle
//
//  Created by John Critchlow on 12/7/22.
//

import Foundation
import Firebase

class MyEventsViewModel: ObservableObject {
    @Published var joinedEvents = [Event]()
    
    init() {
        self.fetchJoinedEvents()
    }
    
    private let service = EventService()
    private let userService = UserService()
    
    func fetchJoinedEvents() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        service.fetchJoinedEvents(forUid: uid) { events in
            self.joinedEvents = events
            print("DEBUG: \(self.joinedEvents)")
            
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
