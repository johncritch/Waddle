//
//  SideMenuView.swift
//  BetterBe
//
//  Created by John Critchlow on 10/28/22.
//

import SwiftUI
import Kingfisher

struct SideMenuView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        
        if let user = authViewModel.currentUser {
            VStack(alignment: .leading, spacing: 32) {
                VStack(alignment: .leading) {
                    KFImage(URL(string: user.profileImageUrl))
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 48, height: 48)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(user.first) \(user.last)")
                            .font(.headline)
                        
                        Text("@\(user.username)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    UserStatsView(viewModel: ProfileViewModel(user: user))
                        .padding(.vertical)
                }
                .padding(.top, 50)
                .padding(.leading)
                
                ForEach(SideMenuViewModel.allCases, id: \.rawValue) { viewModel in
                    if viewModel == .profile {
                        NavigationLink {
                            ProfileView(user: user)
                        } label: {
                            SideMenuOptionRowView(viewModel: viewModel)
                        }
                    } else if viewModel == .logout {
                        Button {
                            authViewModel.signOut()
                        } label: {
                            SideMenuOptionRowView(viewModel: viewModel)
                        }
                        
                    } else {
                        SideMenuOptionRowView(viewModel: viewModel)
                    }
                    
                }
                
                Spacer()
            }
            .background(Color.white)
            .cornerRadius(20)
            .ignoresSafeArea()
            .frame(width: 350)
        }
    }
}
//
//struct SideMenuView_Previews: PreviewProvider {
//    static var previews: some View {
//        ZStack(alignment: .leading) {
//            Rectangle()
//                .fill(.red)
//                .ignoresSafeArea()
//            SideMenuView()
//                .offset()
//        }
//    }
//}
