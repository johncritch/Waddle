//
//  MessageBubble.swift
//  Waddle
//
//  Created by John Critchlow on 12/7/22.
//

import SwiftUI

struct MessageBubble: View {
    @State private var showTime = false
    @State private var messageUser: User = TestingVariables().user
    
    var userService = UserService()
    var userId: String
    var message: Message
    
    var body: some View {
        VStack(alignment: message.uid != userId ? .leading : .trailing) {
            HStack(alignment: .bottom){
                if message.uid != userId {
                    ProfileImage(image: messageUser.profileImageUrl)
                        .frame(width: 20, height: 20)
                        .padding(.vertical, 8)
                }
                Text(message.text)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .foregroundColor(message.uid != userId ? .black : .white)
                    .background(message.uid != userId ? Color.systemGray5 : Color.systemBlue)
                    .cornerRadius(20)
            }
            .frame(maxWidth: 300, alignment: message.uid != userId ? .leading : .trailing)
            .onTapGesture {
                withAnimation {
                    showTime.toggle()
                }
            }
            
            if showTime {
                HStack {
                    Text("\(message.timestamp.formatted(.dateTime.hour().minute()))")
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .padding(message.uid != userId ? .leading : .trailing, 40)
                    if message.uid != userId {
                        Text("\(messageUser.fullname)")
                            .font(.caption2)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: message.uid != userId ? .leading : .trailing)
        .padding(message.uid != userId ? .leading : .trailing)
        .padding(.horizontal, 10)
        .onAppear {
            userService.fetchUser(withUid: message.uid) { user in
                messageUser = user
            }
        }
    }
}

struct MessageBubble_Previews: PreviewProvider {
    static var previews: some View {
        MessageBubble(userId: "abc123", message: TestingVariables().messageReceivedLong)
    }
}
