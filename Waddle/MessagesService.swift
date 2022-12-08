//
//  MessagesService.swift
//  Waddle
//
//  Created by John Critchlow on 12/7/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class MessagesService: ObservableObject {
    @Published private(set) var messages: [Message] = []
    @Published private(set) var lastMessageId = ""
    
    func fetchMessages(eventId: String) {
        Firestore.firestore()
            .collection("events")
            .document(eventId)
            .collection("event-messages")
            .order(by: "timestamp")
            .addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("DEBUG: Error fetching messages documents: \(String(describing: error))")
                return
            }
            
            self.messages = documents.compactMap { document -> Message? in
                do {
                    return try document.data(as: Message.self)
                } catch {
                    print("DEBUG: Error decoding document into Message: \(error)")
                    return nil
                }
            }
                if let id = self.messages.last?.id {
                    self.lastMessageId = id
                }
        }
    }
    
    func sendMessage(uid: String, eventId: String, text: String) {
        do {
            let newMessage = Message(id: "\(UUID())", text: text, uid: uid, timestamp: Date())
            
            try Firestore.firestore()
                .collection("events")
                .document(eventId)
                .collection("event-messages")
                .document()
                .setData(from: newMessage)
        } catch {
            print("Error")
        }
    }
}
