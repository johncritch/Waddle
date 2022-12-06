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
    @State private var showAttendees: Bool = false
    @State private var showUpdateEvent: Bool = false
    
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
                            NavigationLink {
                                ProfileView(user: user)
                            } label: {
                                ProfileImage(image: user.profileImageUrl)
                                    .frame(width: 70, height: 70)
                            }
                            Text(viewModel.event.date.formatted(.dateTime.weekday(.wide)))
                                .font(.subheadline)
                            Text(viewModel.event.date.formatted(.dateTime.day().month()))
                                .multilineTextAlignment(.center)
                                .font(.caption)

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
                                .font(.headline)
                                .multilineTextAlignment(.leading)
                            
                            Text(viewModel.event.caption)
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
                        .padding(.leading, 5)
                    }
                    HStack {
                        Button {
                            viewModel.event.didJoin ?? false ?
                            viewModel.unjoinEvent() :
                            viewModel.joinEvent()
                        } label: {
                            Text(viewModel.event.didJoin ?? false ? "Joined" : "Join")
                                .foregroundColor(viewModel.event.didJoin ?? false ? .green : .gray)
                            Image(systemName: viewModel.event.didJoin ?? false ? "checkmark.square" : "square")
                                .font(.subheadline)
                                .foregroundColor(viewModel.event.didJoin ?? false ? .green : .gray)
                        }
                        .buttonStyle(.bordered)
                        .tint(viewModel.event.didJoin ?? false ? .green : .gray)
                        
                        Button {
                            showAttendees.toggle()
                        } label: {
                            Text(viewModel.event.limited ? "Attendees: Max \(viewModel.event.maxNumber)" : "Attendees")
                        }
                        .buttonStyle(.bordered)
                        .tint(.blue)
                        .sheet(isPresented: $showAttendees) {
                            AttendeesView()
                        }
                        
                        Spacer()
                        
                        if viewModel.event.uid == Auth.auth().currentUser?.uid {
                            Button {
                                showUpdateEvent.toggle()
                            } label: {
                                Image(systemName: "square.and.pencil")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .fullScreenCover(isPresented: $showUpdateEvent, onDismiss: refreshView) {
                                NewEventView(event: viewModel.event)
                            }
                            
                            Button {
                                viewModel.deleteEvent()
                                needsRefresh = true
                            } label: {
                                Image(systemName: "trash")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.top)
                    .padding(.leading, 5)
                }
            }
            .padding(30)
        }
        .frame(maxHeight: 300)
    }
    
    private func refreshView() {
        needsRefresh = true
    }
}

struct EventsRowView_Previews: PreviewProvider {
    static var previews: some View {
        EventsRowView(event: TestingVariables().event, needsRefresh: .constant(false))
            .frame(minHeight: 200, maxHeight: 300)
    }
}
