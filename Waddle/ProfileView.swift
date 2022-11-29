//
//  ProfileView.swift
//  Waddle
//
//  Created by John Critchlow on 10/20/22.
//

import SwiftUI
import Kingfisher
import RefreshableScrollView

struct ProfileView: View {
    @State private var selectedFilter: EventFilterViewModel = .events
    @ObservedObject var viewModel: ProfileViewModel
    @Environment(\.presentationMode) var mode
    @Namespace var animation
    @State var needsRefresh: Bool = false
    
    init(user: User) {
        self.viewModel = ProfileViewModel(user: user)
    }
    
    var body: some View {
        VStack (alignment: .leading) {
            
            headerView
            
            actionButtons
            
            userInfoDetails
            
            eventFilterBar
            
            eventsView
            
            Spacer()
        }
        .navigationBarHidden(true)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(user: TestingVariables().user)
    }
}

extension ProfileView {
    var headerView: some View {
        ZStack(alignment: .bottomLeading) {
            Color(.systemBlue)
                .ignoresSafeArea()
            
            VStack {
                Button {
                    mode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .frame(width: 20, height: 16)
                        .foregroundColor(.white)
                        .offset(x: 16, y: -4)
                }

                
                ProfileImage(image: viewModel.user.profileImageUrl)
                    .frame(width: 72, height: 72)
                .offset(x: 16, y: 24)
            }
        }
        .frame(height: 96)
    }
    
    var actionButtons: some View {
        HStack (spacing: 12){
            Spacer()
            
            Image(systemName: "bell.badge")
                .font(.title3)
                .padding(6)
                .overlay(Circle().stroke(Color.gray, lineWidth: 0.75))
            
            Button {
                //
            } label: {
                Text(viewModel.actionButtonTitle)
                    .font(.subheadline).bold()
                    .frame(width: 120, height: 32)
                    .foregroundColor(.black)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 0.75))
            }

        }
        .padding(.trailing)
        
    }
    
    var userInfoDetails: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(viewModel.user.fullname)
                    .font(.title2).bold()
                
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(Color(.systemBlue))
            }
            
            Text("@\(viewModel.user.username)")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text("Your moms favorite villian")
                .font(.subheadline)
                .padding(.vertical)
            
            HStack (spacing: 24) {
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                    Text("Gothom, NY")
                }
                
                HStack {
                    Image(systemName: "link")
                    Text("www.joker.com")
                }
            }
            .font(.caption)
            .foregroundColor(.gray)
            
            UserStatsView()
            .padding(.vertical)
        }
        .padding(.horizontal)
        
    }
    
    var eventFilterBar: some View {
        HStack {
            ForEach(EventFilterViewModel.allCases, id: \.rawValue) { item in
                VStack {
                    Text(item.title)
                        .font(.subheadline)
                        .fontWeight(selectedFilter == item ? .semibold : .regular)
                        .foregroundColor(selectedFilter == item ? .black : .gray)
                    
                    if selectedFilter == item {
                        Capsule()
                            .foregroundColor(Color(.systemBlue))
                            .frame(height: 3)
                            .matchedGeometryEffect(id: "filter", in: animation)
                    } else {
                        Capsule()
                            .foregroundColor(Color(.clear))
                            .frame(height: 3)
                    }
                }
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        self.selectedFilter = item
                    }
                }
            }
        }
        .overlay(Divider().offset(x: 0, y: 16))
    }
    
    var eventsView: some View {
        RefreshableScrollView {
            LazyVStack {
                ForEach(viewModel.events(forFilter: self.selectedFilter)) { event in
                    EventsRowView(event: event, needsRefresh: $needsRefresh)
                }
            }
        }
        .refreshable {
              do {
                // Sleep for 1 seconds
                try await Task.sleep(nanoseconds: 1 * 1_000_000_000)
              } catch {}
              
            viewModel.fetchUserEvents()
            viewModel.fetchJoinedEvents()
        }
    }
}
