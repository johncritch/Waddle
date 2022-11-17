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
    let title: String
    let timestamp: Timestamp
    let uid: String
    var joined: Int
    let city: String
    let date: Date
    let limited: Bool
    let privateEvent: Bool
    let maxNumber: Int
    var tags: [Tag]
    var user: User?
    var didJoin: Bool? = false
}

//struct TagFromFire: Codable {
//    var id: Int
//    var title: String
//}
