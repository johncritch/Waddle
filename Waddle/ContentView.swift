//
//  ContentView.swift
//  Waddle
//
//  Created by John Critchlow on 10/20/22.
//

import SwiftUI
import Kingfisher

struct ContentView: View {
    @State private var showMenu = false
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        Group {
            if viewModel.userSession == nil {
                LoginView()
            } else {
                mainInterfaceView
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthViewModel())
    }
}

extension ContentView {
    var mainInterfaceView: some View {
        ZStack(alignment: .topLeading) {
            MainTabView()
            
            ZStack {
                Color(.black)
                    .opacity(showMenu ? 0.25 : 0.0)
            }.onTapGesture {
                if showMenu {
                    withAnimation(.easeInOut) {
                        showMenu = false
                    }
                }
            }
            .ignoresSafeArea()
            
            SideMenuView()
                .offset(x: showMenu ? 0 : -350)
        }
        .navigationTitle(showMenu ? "'" : "Home")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if let user = viewModel.currentUser {
                    Button {
                        withAnimation(.easeInOut) {
                            showMenu.toggle()
                        }
                    } label: {
                        KFImage(URL(string: user.profileImageUrl))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 32, height: 32)
                            .clipShape(Circle())
                            .opacity(showMenu ? 0 : 1)
                    }
                    
                }
                Button {
                    viewModel.signOut()
                } label: {
                    Text("Sign Out")
                }
            }
        }
        .onAppear {
            showMenu = false
        }
    }
}
