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
    @Published var followers = [User]()
    @Published var following = [User]()
    @Published var user: User
    
    private let service = EventService()
    private let userService = UserService()
    
    init(user: User) {
        self.user = user
        self.fetchUserEvents()
        self.fetchJoinedEvents()
        self.fetchFollowers()
        self.fetchFollowing()
        checkIfUserFollowsUser()
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

    func followUser() {
        service.followUser(user) {
            self.user.doesFollow = true
        }
    }
    
    func unfollowUser() {
        service.unfollowUser(user) {
            self.user.doesFollow = false
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
    
    func fetchFollowers() {
        guard let uid = user.id else { return }
        
        service.fetchFollowers(forUid: uid) { users in
            self.followers = users
//            print("DEBUG: (2) Followers\(self.followers)")
            
            for i in 0..<users.count {
                let uid = users[i].id
                
                self.userService.fetchUser(withUid: uid!) { user in
                    self.followers[i] = user
                }
            }
            return
        }
        self.followers = []
    }
    
    func fetchFollowing() {
        guard let uid = user.id else { return }
        
        service.fetchFollowing(forUid: uid) { users in
            self.following = users
//            print("DEBUG: (2) Following\(self.following)")
            
            for i in 0..<users.count {
                let uid = users[i].id
                
                self.userService.fetchUser(withUid: uid!) { user in
                    self.following[i] = user
                }
            }
            return
        }
        self.following = []
    }
    
    func fetchJoinedEvents() {
        guard let uid = user.id else { return }
        
        service.fetchJoinedEvents(forUid: uid) { events in
            self.joinedEvents = events
//            print("DEBUG: (2) Joined events\(self.joinedEvents)")
            
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
    
    func checkIfUserFollowsUser() {
        service.checkIfUserFollowsUser(user) { doesFollow in
            if doesFollow {
                self.user.doesFollow = true
            }
        }
    }
}
