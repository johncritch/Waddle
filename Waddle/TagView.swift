//
//  Tag.swift
//  Waddle
//
//  Created by John Critchlow on 11/4/22.
//

import SwiftUI

struct TagView: View {
    @Binding var selectedTags: [Tag]
    var tag: Tag
    var doesChangeColor: Bool = true
    
    var body: some View {
        Button {
            if let tagIndex = selectedTags.firstIndex(of: tag) {
                selectedTags.remove(at: tagIndex)
            } else {
                self.selectedTags.append(tag)
            }
        } label: {
            Text(tag.title)
                .foregroundColor(.white)
                .frame(height: 15)
        }
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.roundedRectangle(radius: 30))
        .tint(selectedTags.contains(tag) && doesChangeColor == true ? .systemGray4 : .systemBlue)
    }
}

struct Tag_Previews: PreviewProvider {
    static var previews: some View {
        let tag = Tag(id: 0, title: "Fun")
        let tagList = [tag, tag, tag]
        let tag2 = Tag(id: 1, title: "Adventure")
        TagView(selectedTags: .constant(tagList), tag: Tag(id: tag2.id, title: tag.title))
    }
}
