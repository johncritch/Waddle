//
//  Message.swift
//  Waddle
//
//  Created by John Critchlow on 12/7/22.
//

import Foundation

struct Message: Identifiable, Codable {
    var id: String
    var text: String
    var uid: String
    var timestamp: Date
}
