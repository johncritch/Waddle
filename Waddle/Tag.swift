//
//  Tag.swift
//  Waddle
//
//  Created by John Critchlow on 11/4/22.
//

import SwiftUI

struct Tag: View {
    var tagName: String
    
    var body: some View {
        Text("  \(tagName)  ")
            .foregroundColor(.white)
            .frame(height: 30)
            .background(Color(.systemBlue))
            .clipShape(Capsule())
    }
}

struct Tag_Previews: PreviewProvider {
    static var previews: some View {
        Tag(tagName: "Adventure")
    }
}
