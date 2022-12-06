//
//  User.swift
//  Waddle
//
//  Created by John Critchlow on 11/1/22.
//

import FirebaseFirestoreSwift
import Firebase

struct User: Identifiable, Decodable {
    @DocumentID var id: String?
    let username: String
    let first: String
    let last: String
    let profileImageUrl: String
    let email: String
    var doesFollow: Bool? = false
    
    var fullname: String {
        return first + " " + last
    }
    
    var isCurrentUser: Bool {
        return Auth.auth().currentUser?.uid == id
    }
}


