//
//  MessageField.swift
//  Waddle
//
//  Created by John Critchlow on 12/7/22.
//

import SwiftUI

struct MessageField: View {
    @EnvironmentObject var messagesService: MessagesService
    @State private var message = ""
    var uid: String
    var eventId: String
    
    var body: some View {
        HStack {
//            CustomTextField(placeholder: Text("Enter your message here"), text: $message)
            TextField("Enter your message here", text: $message, axis: .vertical)
            
            Button {
                messagesService.sendMessage(uid: uid, eventId: eventId, text: message)
                message = ""
            } label: {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(.blue)
                    .cornerRadius(50)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color.systemGray6)
        .cornerRadius(20)
        .padding()
    }
}

struct MessageField_Previews: PreviewProvider {
    static var previews: some View {
        MessageField(uid: "abc123", eventId: "123abc")
            .environmentObject(MessagesService())
    }
}

struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool) -> () = {_ in}
    var commit: () -> () = {}
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                placeholder
                    .opacity(0.5)
            }
            
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
        }
    }
}
