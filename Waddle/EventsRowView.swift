//
//  EventsRowView.swift
//  Waddle
//
//  Created by John Critchlow on 10/20/22.
//

import SwiftUI
import Firebase

struct EventsRowView: View {
    @ObservedObject var viewModel: EventRowViewModel
    @Binding var needsRefresh: Bool
    
    init(event: Event, needsRefresh: Binding<Bool>) {
        self.viewModel = EventRowViewModel(event: event)
        self._needsRefresh = needsRefresh
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .padding(.horizontal)
                .padding(.vertical, 10)
                .shadow(radius: 4)
            VStack(alignment: .leading){
                
                if let user = viewModel.event.user {
                    //Profile
                    HStack(alignment: .top, spacing: 10) {
                        VStack (alignment: .center) {
                            ProfileImage(image: user.profileImageUrl)
                                .frame(width: 70, height: 70)
                            Text(viewModel.event.date.formatted(.dateTime.weekday(.wide)))
                            Text(viewModel.event.date.formatted(.dateTime.day().month()))
                                .multilineTextAlignment(.center)
                                .font(.caption)
                            Divider()
                            Text("Joined")
                                .font(.caption)
                            HStack {
                                Button {
                                    // action goes here
                                } label: {
                                    Text("\(viewModel.event.joined)")
                                        .font(.caption)
                                }
                                .buttonStyle(.bordered)
                                .tint(.blue)
                                Text("/")
                                Button {
                                    // action goes here
                                } label: {
                                    Text("\(viewModel.event.maxNumber)")
                                        .font(.caption)
                                }
                                .buttonStyle(.bordered)
                                .tint(.blue)

                            }
                        }
                        .frame(width: 80)
                        
                        //User
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(user.fullname)
                                    .font(.subheadline).bold()
                                
                                Text("@\(user.username)")
                                    .foregroundColor(.gray)
                                    .font(.caption)
                                
                                Text("2w")
                                    .foregroundColor(.gray)
                                    .font(.caption)
                            }
                            
                            //Event Details
                            Text(viewModel.event.title)
                                .font(.subheadline)
                                .multilineTextAlignment(.leading)
                            
                            Text(viewModel.event.caption)
                                .font(.subheadline)
                                .multilineTextAlignment(.leading)
                            Text(viewModel.event.city)
                                .font(.subheadline)
                                .multilineTextAlignment(.leading)
                            Text(String(viewModel.event.maxNumber))
                                .font(.subheadline)
                                .multilineTextAlignment(.leading)
                        }
                    }
                }
                //Action Buttons
                VStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.event.tags) { tag in
                                TagView(selectedTags: .constant([]), tag: tag, doesChangeColor: false)
                            }
                            Spacer()
                        }
                        .padding(.leading)
                    }
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
                            viewModel.event.didJoin ?? false ?
                            viewModel.unjoinEvent() :
                            viewModel.joinEvent()
                        } label: {
                            Image(systemName: viewModel.event.didJoin ?? false ? "heart.fill" : "heart")
                                .font(.subheadline)
                                .foregroundColor(viewModel.event.didJoin ?? false ? .red : .gray)
                        }
                        Spacer()
                        Button {
                            viewModel.deleteEvent()
                            needsRefresh = true
                        } label: {
                            Image(systemName: "trash")
                                .font(.subheadline)
                        }
                        
                    }
                    .padding(.horizontal)
                    .padding(.top)
                .foregroundColor(.gray)
                }
            }
            .padding(30)
        }
        .frame(maxHeight: 300)
    }
}

struct EventsRowView_Previews: PreviewProvider {
    static var previews: some View {
        EventsRowView(event: TestingVariables().event, needsRefresh: .constant(false))
            .frame(minHeight: 200, maxHeight: 300)
    }
}
