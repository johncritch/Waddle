//
//  TestingVariables.swift
//  Waddle
//
//  Created by John Critchlow on 11/3/22.
//

import Foundation
import Firebase

struct TestingVariables {
    let user = User(username: "johncritch",
                    first: "John",
                    last: "Critchlow",
                    profileImageUrl: "https://firebasestorage.googleapis.com:443/v0/b/waddle-c1750.appspot.com/o/profile_images%2F7A1A955C-7356-49E3-811C-B01E80154609?alt=media&token=d00410a7-be11-4a00-bae5-0affcf53340e",
                    email: "johnnyrcritch@gmail.com")
    
    let event = Event(caption: "This is a sample event that says absolutely nothing",
                      title: "This is the title",
                      timestamp: Timestamp(date: Date()),
                      uid: "KY3W8mKHt2Oyp5J7dH4RGOTyjPn1",
                      joined: 24,
                      city: "Provo",
                      date: Date(),
                      limited: false,
                      privateEvent: false,
                      maxNumber: 8,
                      tags: [Tag(id: 1, title: "Adventure")],
                      user: User(username: "johncritch",
                                 first: "John",
                                 last: "Critchlow",
                                 profileImageUrl: "https://firebasestorage.googleapis.com:443/v0/b/waddle-c1750.appspot.com/o/profile_images%2F7A1A955C-7356-49E3-811C-B01E80154609?alt=media&token=d00410a7-be11-4a00-bae5-0affcf53340e",
                                 email: "johnnyrcritch@gmail.com"))
}
