//
//  ProfileImage.swift
//  Waddle
//
//  Created by John Critchlow on 11/3/22.
//

import SwiftUI
import Kingfisher

struct ProfileImage: View {
    let image: String
    var body: some View {
        KFImage(URL(string: image))
            .resizable()
            .scaledToFill()
            .clipShape(Circle())
    }
}

struct ProfileImage_Previews: PreviewProvider {
    static var previews: some View {
        ProfileImage(image: "https://firebasestorage.googleapis.com:443/v0/b/waddle-c1750.appspot.com/o/profile_images%2F7A1A955C-7356-49E3-811C-B01E80154609?alt=media&token=d00410a7-be11-4a00-bae5-0affcf53340e")
            .frame(width: 350, height: 350)
    }
}
