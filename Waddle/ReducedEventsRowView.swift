//
//  ReducedEventsRowView.swift
//  Waddle
//
//  Created by John Critchlow on 12/7/22.
//

import SwiftUI

struct ReducedEventsRowView: View {
    @ObservedObject var viewModel: EventRowViewModel
    
    init(event: Event) {
        self.viewModel = EventRowViewModel(event: event)
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .padding(.horizontal)
                .padding(.vertical, 20)
                .shadow(radius: 4)
            VStack(alignment: .leading){
                
                if let user = viewModel.event.user {
                    //Profile
                    HStack(alignment: .top, spacing: 10) {
                        VStack (alignment: .center) {
//                            NavigationLink {
//                                ProfileView(user: user)
//                            } label: {
//                                ProfileImage(image: user.profileImageUrl)
//                                    .frame(width: 50, height: 50)
//                            }
                            Spacer()
                            Text(viewModel.event.date.formatted(.dateTime.weekday()))
                                .font(.subheadline)
                            Text(viewModel.event.date.formatted(.dateTime.day().month()))
                                .font(.caption)
                            Spacer()

                        }
                        .padding(.horizontal, -8)
                        .frame(width: 35)
                        
                        Divider()
                        //User
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                
                                NavigationLink {
                                    ProfileView(user: user)
                                } label: {
                                    Text(user.fullname)
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                }
                                
                                Text("@\(user.username)")
                                    .foregroundColor(.gray)
                                    .font(.caption)
                                
                                Text("2w")
                                    .foregroundColor(.gray)
                                    .font(.caption)
                            }
                            //Event Details
                            Text(viewModel.event.title)
                                .font(.headline)
                                .multilineTextAlignment(.leading)
                            
                            Text(viewModel.event.caption)
                                .font(.subheadline)
                                .multilineTextAlignment(.leading)
                        }
                        Divider()
                        VStack (alignment: .leading) {
                            Spacer()
                            NavigationLink {
                                ChatRoomView(event: viewModel.event)
                            } label: {
                                Image(systemName: "text.bubble")
                                    .foregroundColor(.blue)
                            }

                            Spacer()

                        }
                        .frame(width: 35)
                    }
                }
            }
            .padding(30)
        }
        .frame(maxHeight: 100)
    }
}

struct ReducedEventsRowView_Previews: PreviewProvider {
    static var previews: some View {
        ReducedEventsRowView(event: TestingVariables().event)
    }
}
