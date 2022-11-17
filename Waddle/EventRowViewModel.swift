//
//  EventRowViewModel.swift
//  Waddle
//
//  Created by John Critchlow on 11/3/22.
//

import Foundation

class EventRowViewModel: ObservableObject {
    @Published var event: Event
    private let service = EventService()
    
    init(event: Event) {
        self.event = event
        checkIfUserJoinedEvent()
        print("DEBUG: \(event)")
    }
    
    func joinEvent() {
        service.joinEvent(event) {
            self.event.didJoin = true
        }
    }
    
    func unjoinEvent() {
        service.unjoinEvent(event) {
            self.event.didJoin = false
        }
    }
    
    func checkIfUserJoinedEvent() {
        service.checkIfUserJoinedEvent(event) { didJoin in
            if didJoin {
                self.event.didJoin = true
            }
        }
    }
}
