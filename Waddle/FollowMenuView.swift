//
//  FollowMenuView.swift
//  Waddle
//
//  Created by John Critchlow on 12/6/22.
//

import SwiftUI
import RefreshableScrollView

struct FollowMenuView: View {
    var users: [User]
    
    var body: some View {
        LazyVStack {
            ForEach(users) { user in
                UserRowView(user: user)
            }
        }
    }
}

struct FollowMenuView_Previews: PreviewProvider {
    static var previews: some View {
        FollowMenuView(users: [TestingVariables().user])
    }
}
