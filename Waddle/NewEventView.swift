//
//  NewEventView.swift
//  BetterBe
//
//  Created by John Critchlow on 10/28/22.
//

import SwiftUI
import Kingfisher

struct NewEventView: View {
    @State private var title = ""
    @State private var caption = ""
    @State private var day = Date()
    @State private var city = ""
    @State private var privateEvent = false
    @State private var limitedCapacity = false
    @State private var maxNumberJoin = 0
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var viewModel = UploadEventViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Cancel")
                        .foregroundColor(Color(.systemBlue))
                }
                Spacer()
                Button {
                    viewModel.uploadEvent(withCaption: caption)
                } label: {
                    Text("Publish")
                        .bold()
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color(.systemBlue))
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }

            }
            .padding()
            
            VStack {
                TextField("Title:", text: $title)
                TextArea("What's happening?", text: $caption)
                TextArea("What's happening?", text: $caption)
                TextArea("What's happening?", text: $caption)
                TextArea("What's happening?", text: $caption)
            }
            .padding()
        }
        .onReceive(viewModel.$didUploadEvent) { success in
            if success {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct NewEventView_Previews: PreviewProvider {
    static var previews: some View {
        NewEventView()
            .environmentObject(AuthViewModel())
    }
}
