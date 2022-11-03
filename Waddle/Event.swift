//
//  Event.swift
//  Waddle
//
//  Created by John Critchlow on 11/3/22.
//

import FirebaseFirestoreSwift
import Firebase

struct Event: Identifiable, Decodable {
    @DocumentID var id: String?
    let caption: String
    let timestamp: Timestamp
    let uid: String
    var joined: Int
    
    var user: User?
    var didJoin: Bool? = false
}
