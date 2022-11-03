//
//  UserRowView.swift
//  Waddle
//
//  Created by John Critchlow on 10/20/22.
//

import SwiftUI

struct UserRowView: View {
    let user: User
    
    var body: some View {
        HStack (spacing: 12) {
            ProfileImage(image: user.profileImageUrl)
                .frame(width:56, height: 56)
            
            VStack (alignment: .leading, spacing: 4) {
                Text(user.username)
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.black)
                
                Text(user.fullname)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}

struct UserRowView_Previews: PreviewProvider {
    static var previews: some View {
        UserRowView(user: User(username: "john", first: "John", last: "Critchlow", profileImageUrl: "https://firebasestorage.googleapis.com:443/v0/b/waddle-c1750.appspot.com/o/profile_images%2F5F0B5D06-C8E0-41E7-B39F-8627B814DF1C?alt=media&token=bf2fd248-a0ce-4d34-a561-779f78a53e3e", email: "johnny@gmail.com"))
    }
}
