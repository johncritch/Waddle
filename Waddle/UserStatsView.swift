//
//  UserStatsView.swift
//  BetterBe
//
//  Created by John Critchlow on 10/28/22.
//

import SwiftUI
import RefreshableScrollView

struct UserStatsView: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        HStack (spacing: 24) {
            HStack (spacing: 4){
                NavigationLink {
                    followingView
                } label: {
                    Text(String(viewModel.following.count))
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.black)
                    
                    Text("Following")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            HStack (spacing: 4){
                NavigationLink {
                    followersView
                } label: {
                    Text(String(viewModel.followers.count))
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.black)
                    
                    Text("Followers")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .onAppear {
            viewModel.fetchFollowers()
            viewModel.fetchFollowing()
        }
    }
}

struct UserStatsView_Previews: PreviewProvider {
    static var previews: some View {
        UserStatsView(viewModel: ProfileViewModel(user: TestingVariables().user))
    }
}

extension UserStatsView {
    var followersView: some View {
        FollowMenuView(users: viewModel.followers)
    }
    
    var followingView: some View {
        FollowMenuView(users: viewModel.following)
    }
}
