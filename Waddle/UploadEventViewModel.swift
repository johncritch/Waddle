//
//  UploadEventViewModel.swift
//  Waddle
//
//  Created by John Critchlow on 11/3/22.
//

import Foundation

class UploadEventViewModel: ObservableObject {
    @Published var didUploadEvent = false
    let service = EventService()
    
    func uploadEvent(withCaption caption: String,
                     withTitle title: String,
                     withDate date: Date,
                     withCity city: String,
                     withPrivateEvent privateEvent: Bool,
                     withLimited limited: Bool,
                     withMaxNumber maxNumber: Int,
                     withTags tags: [Tag]
    ) {
        service.uploadEvent(caption: caption,
                            title: title,
                            date: date,
                            city: city,
                            privateEvent: privateEvent,
                            limited: limited,
                            maxNumber: maxNumber,
                            tags: tags
        ) { success in
            if success {
                self.didUploadEvent = true
            } else {
                print("DEBUG: Not successful upload")
            }
        }
    }
    
    func updateEvent(withEvent event: Event,
                     withCaption caption: String,
                     withTitle title: String,
                     withDate date: Date,
                     withCity city: String,
                     withPrivateEvent privateEvent: Bool,
                     withLimited limited: Bool,
                     withMaxNumber maxNumber: Int,
                     withTags tags: [Tag]
        ) {
        service.updateEvent(event,
                            caption: caption,
                            title: title,
                            date: date,
                            city: city,
                            privateEvent: privateEvent,
                            limited: limited,
                            maxNumber: maxNumber,
                            tags: tags
                            
        ) {
            self.didUploadEvent = true
        }
    }
}
