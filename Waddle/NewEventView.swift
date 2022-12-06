//
//  NewEventView.swift
//  BetterBe
//
//  Created by John Critchlow on 10/28/22.
//

import SwiftUI
import Kingfisher

class NewEvent: ObservableObject {
    @Published var title: String = ""
    @Published var caption = ""
    @Published var date = Date()
    @Published var city = "Provo"
    @Published var privateEvent = false
    @Published var limitedCapacity = false
    @Published var maxNumberJoin: Int = 0
    @Published var tags = [Tag]()
    
    func updatedVariables(event: Event) {
        title = event.title
        caption = event.caption
        date = event.date
        city = event.city
        privateEvent = event.privateEvent
        limitedCapacity = event.limited
        maxNumberJoin = event.maxNumber
        tags = event.tags
    }
}

struct NewEventView: View {
    
    var event: Event?
    
    @ObservedObject var newEvent = NewEvent()
    @State private var showTagsMenu = false
    @State private var selectedTags = [Tag]()
    
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
                    if event != nil {
                        if let updatedEvent = event {
                            viewModel.updateEvent(withEvent: updatedEvent,
                                                  withCaption: newEvent.caption,
                                                  withTitle: newEvent.title,
                                                  withDate: newEvent.date,
                                                  withCity: newEvent.city,
                                                  withPrivateEvent: newEvent.privateEvent,
                                                  withLimited: newEvent.limitedCapacity,
                                                  withMaxNumber: newEvent.maxNumberJoin,
                                                  withTags: newEvent.tags
                            )
                        }
                    } else {
                        viewModel.uploadEvent(withCaption: newEvent.caption,
                                              withTitle: newEvent.title,
                                              withDate: newEvent.date,
                                              withCity: newEvent.city,
                                              withPrivateEvent: newEvent.privateEvent,
                                              withLimited: newEvent.limitedCapacity,
                                              withMaxNumber: newEvent.maxNumberJoin,
                                              withTags: newEvent.tags
                        )
                    }
                } label: {
                    Text((event != nil) ? "Update" : "Publish")
                        .bold()
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color(.systemBlue))
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }

            }
            .padding(.horizontal, 30)
            
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
                    .padding(.horizontal)
                    .padding(.vertical)
                    .shadow(radius: 4)
                VStack {
                    
                    VStack(alignment: .leading) {
                        TextField("Title goes here..", text: $newEvent.title)
                            .font(.title2)
                            .padding(.horizontal, 24)
                            .padding(.top, 20)
                        TextArea("Description goes here..", text: $newEvent.caption)
                            .padding(.horizontal, 18)
                        tagsRow
                            .padding(.horizontal, 24)
                        HStack{
                            Button {
                                // City Picker
                            } label: {
                                Text(newEvent.city)
                            }
                            Spacer()
                            DatePicker("", selection: $newEvent.date, displayedComponents: [.date])
                            
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
            
            eventMenu
        }
    }

    var eventMenu: some View {
        VStack {
            VStack(alignment: .leading) {
                Toggle("Private Event?", isOn: $newEvent.privateEvent)
                    .padding(.trailing, 170)
                if newEvent.privateEvent {
                    Text("Only your friends will see this event.")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Toggle("Limited Capacity?", isOn: $newEvent.limitedCapacity)
                .padding(.trailing, 170)
            }
            .padding(.leading, 24)
            if newEvent.limitedCapacity {
                HStack(spacing: 30) {
                    Text("Maximum Capacity")
                    Picker("Maximum Capacity", selection: $newEvent.maxNumberJoin) {
                        ForEach(1..<100) {
                            Text("\($0)")
                        }
                    }
                    Spacer()
                }
                .padding(.leading, 24)
            }
        }
        .onAppear {
            if event != nil {
                if let updatedEvent = event {
                    newEvent.updatedVariables(event: updatedEvent)
                }
            }
        }
    }
    var tagsRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                
                Button {
                    showTagsMenu = true
                } label: {
                    if newEvent.tags.isEmpty {
                        Text("Add a tag")
                            .frame(height: 15)
                    }
                    Image(systemName: "plus")
                        .frame(height: 15)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 30))
                .sheet(isPresented: $showTagsMenu) {
                    TagsMenuView(tags: $newEvent.tags)
                }
                
                ForEach(newEvent.tags, id: \.id) { tag in
                    TagView(selectedTags: $selectedTags, tag: tag)
                }
            }
        }
    }
}

struct NewEventView_Previews: PreviewProvider {
    static var previews: some View {
        NewEventView(event: TestingVariables().event)
            .environmentObject(AuthViewModel())
    }
}
