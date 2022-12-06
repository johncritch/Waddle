//
//  EventService.swift
//  Waddle
//
//  Created by John Critchlow on 11/3/22.
//

import Firebase

struct EventService {
    
    func uploadEvent(caption: String,
                     title: String,
                     date: Date,
                     city: String,
                     privateEvent: Bool,
                     limited: Bool,
                     maxNumber: Int,
                     tags: [Tag],
                     completion: @escaping(Bool) -> Void
    ) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let data = ["uid": uid,
                    "caption": caption,
                    "title": title,
                    "date": date,
                    "city": city,
                    "privateEvent": privateEvent,
                    "limited": limited,
                    "maxNumber": maxNumber,
                    "tags": transformArray(tags: tags),
                    "joined": 0,
                    "timestamp": Timestamp(date: Date())
        ] as [String: Any]
        
        Firestore.firestore().collection("events").document()
            .setData(data) { error in
                if let error = error {
                    print("DEBUG: Failed to upload the event with error: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                completion(true)
            }
    }
    
    func deleteEvent(_ event: Event, completion: @escaping() -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let eventId = event.id else { return }
        
        if event.uid != uid {
            print("DEBUG: Not the current user")
            return
        }
        
        let eventRenf = Firestore.firestore().collection("events").document(eventId)
        
        eventRenf.delete { _ in
            completion()
        }
    }
    
    func fetchEvents(completion: @escaping([Event]) -> Void) {
        Firestore.firestore().collection("events")
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                
                let events = documents.compactMap({ try? $0.data(as: Event.self )})
                completion(events)
            }
    }
    
    func fetchEvents(forUid uid: String, completion: @escaping([Event]) -> Void) {
        Firestore.firestore().collection("events")
            .whereField("uid", isEqualTo: uid)
//            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                
                let events = documents.compactMap({ try? $0.data(as: Event.self )})
                completion(events.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() }))
            }
    }
    
    func transformArray(tags: [Tag]) -> [[String: Any]] {
        var newList: [[String: Any]] = []
        
        for tag in tags {
            var tempDictionary = [String: Any]()
            tempDictionary["id"] = tag.id
            tempDictionary["title"] = tag.title
            newList.append(tempDictionary)
        }
        return newList
    }
}

// MARK: - Join

extension EventService {
    
    func followUser(_ user: User, completion: @escaping() -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let userId = user.id else { return }
        
        let userFollowingRef = Firestore.firestore().collection("users").document(uid).collection("user-following")
//        let userFollowingRenf = Firestore.firestore().collection("users").document(userId)
        let userFollowedRef = Firestore.firestore().collection("users").document(userId).collection("user-followers")
//        let userFollowedRenf = Firestore.firestore().collection("users").document(uid)
        
        userFollowingRef.document(userId).setData([:]) { _ in
            completion()
        }
        userFollowedRef.document(uid).setData([:]) { _ in
            completion()
        }
        
//        userFollowingRenf.getDocument { snapshot, _ in
//            if let data = snapshot {
//                if let numFollowers: Int = data["followers"] as? Int {
//                    Firestore.firestore().collection("events").document(eventId)
//                        .updateData(["joined": numJoined + 1]) { _ in
//                            userJoinedRef.document(eventId).setData([:]) { _ in
//                                completion()
//                            }
//                        }
//                }
//            }
//        }
    }
    
    func unfollowUser(_ user: User, completion: @escaping() -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let userId = user.id else { return }
        
        let userFollowingRef = Firestore.firestore().collection("users").document(uid).collection("user-following")
//        let userFollowingRenf = Firestore.firestore().collection("users").document(userId)
        let userFollowedRef = Firestore.firestore().collection("users").document(userId).collection("user-followers")
//        let userFollowedRenf = Firestore.firestore().collection("users").document(uid)
        
        userFollowingRef.document(userId).delete { _ in
            completion()
        }
        userFollowedRef.document(uid).delete { _ in
            completion()
        }
        
//        eventRenf.getDocument { snapshot, _ in
//            if let data = snapshot {
//                if let numJoined: Int = data["joined"] as? Int {
//                    guard numJoined > 0 else { return }
//                    Firestore.firestore().collection("events").document(eventId)
//                        .updateData(["joined": numJoined - 1]) { _ in
//                            userJoinedRef.document(eventId).delete { _ in
//                                completion()
//                            }
//                        }
//                }
//            }
//        }
    }
    
    func checkIfUserFollowsUser(_ user: User, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let userId = user.id else { return }
        
        Firestore.firestore().collection("users")
            .document(uid)
            .collection("user-following")
            .document(userId)
            .getDocument { snapshot, _ in
                guard let snapshot = snapshot else { return }
                completion(snapshot.exists)
            }
    }
    
    func joinEvent(_ event: Event, completion: @escaping() -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let eventId = event.id else { return }
        
        let userJoinedRef = Firestore.firestore().collection("users").document(uid).collection("user-joined")
        let eventRenf = Firestore.firestore().collection("events").document(eventId)
        
        eventRenf.getDocument { snapshot, _ in
            if let data = snapshot {
                if let numJoined: Int = data["joined"] as? Int {
                    Firestore.firestore().collection("events").document(eventId)
                        .updateData(["joined": numJoined + 1]) { _ in
                            userJoinedRef.document(eventId).setData([:]) { _ in
                                completion()
                            }
                        }
                }
            }
        }
    }
    
    func unjoinEvent(_ event: Event, completion: @escaping() -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let eventId = event.id else { return }
        
        let userJoinedRef = Firestore.firestore().collection("users").document(uid).collection("user-joined")
        let eventRenf = Firestore.firestore().collection("events").document(eventId)
        
        eventRenf.getDocument { snapshot, _ in
            if let data = snapshot {
                if let numJoined: Int = data["joined"] as? Int {
                    guard numJoined > 0 else { return }
                    Firestore.firestore().collection("events").document(eventId)
                        .updateData(["joined": numJoined - 1]) { _ in
                            userJoinedRef.document(eventId).delete { _ in
                                completion()
                            }
                        }
                }
            }
        }
    }
    
    func checkIfUserJoinedEvent(_ event: Event, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let eventId = event.id else { return }
        
        Firestore.firestore().collection("users")
            .document(uid)
            .collection("user-joined")
            .document(eventId)
            .getDocument { snapshot, _ in
                guard let snapshot = snapshot else { return }
                completion(snapshot.exists)
            }
    }
    
    func fetchJoinedEvents(forUid uid: String, completion: @escaping([Event]) -> Void) {
        var events = [Event]()
        
        print("DEBUG: Joined Events: \(events)")
        
        Firestore.firestore().collection("users")
            .document(uid)
            .collection("user-joined")
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                
                documents.forEach { doc in
                    let eventId = doc.documentID
                    
                    Firestore.firestore().collection("events")
                        .document(eventId)
                        .getDocument { snapshot, _ in
                            guard let event = try? snapshot?.data(as: Event.self) else { return }
                            events.append(event)
                            print("DEBUG: Joined Events: \(events)")
                            completion(events)
                        }
                }
            }
    }
    
    func updateEvent(_ event: Event,
                     caption: String,
                     title: String,
                     date: Date,
                     city: String,
                     privateEvent: Bool,
                     limited: Bool,
                     maxNumber: Int,
                     tags: [Tag],
                     completion: @escaping() -> Void) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let eventId = event.id else { return }
        
        let updatedData = ["uid": uid,
                    "caption": caption,
                    "title": title,
                    "date": date,
                    "city": city,
                    "privateEvent": privateEvent,
                    "limited": limited,
                    "maxNumber": maxNumber,
                    "tags": transformArray(tags: tags),
                    "joined": 0,
                    "timestamp": Timestamp(date: Date())
        ] as [String: Any]
    
        let eventRenf = Firestore.firestore().collection("events").document(eventId)
        
        eventRenf.getDocument { snapshot, _ in
            Firestore.firestore().collection("events").document(eventId)
                .updateData(updatedData) { error in
                    if let error = error {
                        print("DEBUG: Failed to upload the event with error: \(error.localizedDescription)")
                        completion()
                        return
                    }
                    completion()
                }
        }
    }
}
