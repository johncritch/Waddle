//
//  User.swift
//  Waddle
//
//  Created by John Critchlow on 11/1/22.
//

import FirebaseFirestoreSwift

struct User: Identifiable, Decodable {
    @DocumentID var id: String?
    let username: String
    let first: String
    let last: String
    let profileImageUrl: String
    let email: String
    
    var fullname: String {
        return first + " " + last
    }
}


