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
    @State private var city = "Provo"
    @State private var privateEvent = false
    @State private var limitedCapacity = false
    @State private var maxNumberJoin: Int = 0
    @State private var tags = ["Sports", "Girls","Women", "Party","Dugs", "Alcohol","Fun Stuff", "Adventure",]
    
    @State private var showTitleInputArea = false
    @State private var showCaptionInputArea = false
    @State private var showCityInputArea = false
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var viewModel = UploadEventViewModel()
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .shadow(radius: 4)
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
                    .padding(.horizontal, 40)
                    .padding(.top, 30)
                    
                    VStack(alignment: .leading) {
                        TextField("Title goes here..", text: $title)
                            .font(.title2)
                            .padding(.horizontal, 24)
                        TextArea("Description goes here..", text: $caption)
                            .padding(.horizontal, 18)
                        tagsRow
                            .padding(.horizontal, 24)
                        HStack{
                            Button {
                                // City Picker
                            } label: {
                                Text(city)
                            }
                            Spacer()
                            DatePicker("", selection: $day, displayedComponents: [.date])
                            
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 20)
                    }
                    .padding()
                }
                .onReceive(viewModel.$didUploadEvent) { success in
                    if success {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .frame(maxHeight: 300)
            .blur(radius: showTitleInputArea || showCityInputArea || showCaptionInputArea ? 8 : 0)
            .onTapGesture {
                withAnimation {
                    showTitleInputArea = false
                    showCaptionInputArea = false
                    showCityInputArea = false
                }
            }
            if showTitleInputArea {
                InputArea(text: $title, inputName: "Title...")
            }
            if showCaptionInputArea {
                InputArea(text: $caption, inputName: "Description...")
            }
            if showCityInputArea {
                InputArea(text: $caption, inputName: "City...")
            }
            
            eventMenu
        }
    }

    var eventMenu: some View {
        VStack {
            VStack(alignment: .leading) {
                Toggle("Private Event?", isOn: $privateEvent)
                    .padding(.trailing, 170)
                if privateEvent {
                    Text("Only your friends will see this event.")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Toggle("Limited Capacity?", isOn: $limitedCapacity)
                .padding(.trailing, 170)
            }
            .padding(.leading, 24)
            if limitedCapacity {
                HStack(spacing: 30) {
                    Text("Maximum Capacity")
                    Picker("Maximum Capacity", selection: $maxNumberJoin) {
                        ForEach(1..<100) {
                            Text("\($0)")
                        }
                    }
                    Spacer()
                }
                .padding(.leading, 24)
            }
        }
    }
    var tagsRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                
                Button {
                    //
                } label: {
                    if tags.isEmpty {
                        (Text("  Add a tag ") + Text(Image(systemName: "plus")) + Text(" "))
                            .foregroundColor(.white)
                            .frame(height: 30)
                            .background(Color(.systemBlue))
                            .clipShape(Capsule())
                    } else {
                        Capsule()
                            .fill(Color(.systemBlue))
                            .frame(width: 30, height: 30)
                            .clipShape(Capsule())
                            .overlay {
                                Image(systemName: "plus")
                                    .foregroundColor(.white)
                            }
                    }
                }
                
                ForEach(tags, id: \.self) { tag in
                    Tag(tagName: tag)
                }
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
