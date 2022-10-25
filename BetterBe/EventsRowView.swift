//
//  EventsRowView.swift
//  Waddle
//
//  Created by John Critchlow on 10/20/22.
//

import SwiftUI

struct EventsRowView: View {
    var body: some View {
        VStack(alignment: .leading){
            HStack(alignment: .top, spacing: 12) {
                //Profile
                Circle()
                    .frame(width: 56, height: 56)
                    .foregroundColor(Color(.systemBlue))
                
                //User
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Bruce Wayne")
                            .font(.subheadline).bold()
                        
                        Text("@batman")
                            .foregroundColor(.gray)
                            .font(.caption)
                        
                        Text("2w")
                            .foregroundColor(.gray)
                            .font(.caption)
                    }
                    
                    //Event Details
                    Text("I believe in Harvy Dent")
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                }
            }
            //Action Buttons
            HStack {
                Button {
                    // action goes here
                } label: {
                    Image(systemName: "bubble.left")
                        .font(.subheadline)
                }
                Spacer()
                Button {
                    // action goes here
                } label: {
                    Image(systemName: "arrow.2.squarepath")
                        .font(.subheadline)
                }
                Spacer()
                Button {
                    // action goes here
                } label: {
                    Image(systemName: "heart")
                        .font(.subheadline)
                }
                Spacer()
                Button {
                    // action goes here
                } label: {
                    Image(systemName: "bookmark")
                        .font(.subheadline)
                }

            }
            .padding()
            .foregroundColor(.gray)
            
            Divider()
        }
        .padding()
    }
}

struct EventsRowView_Previews: PreviewProvider {
    static var previews: some View {
        EventsRowView()
    }
}
