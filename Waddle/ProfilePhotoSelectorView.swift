//
//  ProfilePhotoSelectorView.swift
//  Waddle
//
//  Created by John Critchlow on 10/29/22.
//

import SwiftUI

struct ProfilePhotoSelectorView: View {
    var body: some View {
        VStack {
            AuthHeaderView(title1: "Create your account",
                            title2: "Add a a profile picture")
            
            Button {
                print("pick image here...")
            } label: {
                Image(systemName: "photo.circle")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 180, height: 180)
                    .padding(.top, 44)
            }

            
            Spacer()
        }
        .ignoresSafeArea()
    }
}

struct ProfilePhotoSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePhotoSelectorView()
    }
}
