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
    
    func uploadEvent(withCaption caption: String) {
        service.uploadEvent(caption: caption) { success in
            if success {
                self.didUploadEvent = true
            } else {
                // show error message to user
            }
        }
    }
}
