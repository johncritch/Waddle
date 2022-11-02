//
//  ContentView.swift
//  Waddle
//
//  Created by John Critchlow on 10/20/22.
//

import SwiftUI

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
//                .navigationBarHidden(showMenu)
            
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
                Button {
                    withAnimation(.easeInOut) {
                        showMenu.toggle()
                    }
                } label: {
                    Circle()
                        .frame(width: 32, height: 32)
                        .opacity(showMenu ? 0 : 1)
                }
            }
        }
        .onAppear {
            showMenu = false
        }
    }
}
