//
//  ChatRoomView.swift
//  Waddle
//
//  Created by John Critchlow on 12/7/22.
//

import SwiftUI
import Firebase

struct ChatRoomView: View {
    @StateObject var messagesService = MessagesService()
    
    var event: Event
    var userId = Auth.auth().currentUser?.uid
    
    var body: some View {
        VStack {
            VStack {
                ZStack {
                    HStack {
                        Text(event.title)
                            .font(.title2)
                            .bold()
                        Spacer()
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
                    
                    HStack {
                        Spacer()
                        HStack(spacing: -15) {
                            ForEach(1..<5) { i in
                                Circle()
                                    .frame(width: 30)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                Divider()
                ScrollViewReader { proxy in
                    ScrollView {
                        ForEach(messagesService.messages) { message in
                            MessageBubble(userId: userId ?? "abc123", message: message)
                        }
                    }
                    .padding(.top, 10)
                    .background(.white)
                    .onChange(of: messagesService.lastMessageId) { id in
                        withAnimation {
                            proxy.scrollTo(id, anchor: .bottom)
                        }
                    }
                }
            }
            
            if let uid = userId {
                if let eventId = event.id {
                    MessageField(uid: uid, eventId: eventId)
                        .environmentObject(messagesService)
                }
            }
        }
        .onAppear {
            if let eventId = event.id {
                messagesService.fetchMessages(eventId: eventId)
            }
        }
    }
}

struct ChatRoomView_Previews: PreviewProvider {
    static var previews: some View {
        ChatRoomView(event: TestingVariables().event)
    }
}


