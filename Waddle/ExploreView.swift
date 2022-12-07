//
//  ExploreView.swift
//  Waddle
//
//  Created by John Critchlow on 10/20/22.
//

import SwiftUI
import CoreLocation
import CoreLocationUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()

    @Published var location: CLLocationCoordinate2D?

    override init() {
        super.init()
        manager.delegate = self
    }

    func requestLocation() {
        manager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
    }
}

struct ExploreView: View {
    @ObservedObject var viewModel = ExploreViewModel()
    @StateObject var locationManager = LocationManager()
    @State var needsRefresh: Bool = false
    
    var body: some View {
        VStack {
            SearchBar(text: $viewModel.searchText)
                .padding()
            ScrollView {
                LazyVStack {
                    if !viewModel.searchableEvents.isEmpty {
                        Text("Events")
                        ForEach(viewModel.searchableEvents) { event in
                            EventsRowView(event: event, needsRefresh: $needsRefresh)
                        }
                    }
                    if !viewModel.searchableUsers.isEmpty {
                        Text("Users")
                        ForEach(viewModel.searchableUsers) { user in
                            NavigationLink {
                                ProfileView(user: user)
                            } label: {
                                UserRowView(user: user)
                            }
                        }
                    }
                }
            }
            LocationButton {
                locationManager.requestLocation()
            }
            .frame(height: 44)
            .padding()
        }
        .navigationTitle("Explore")
        .navigationBarTitleDisplayMode(.inline)
//        .onAppear {
//            if locationManager.location == nil {
//                locationManager.requestLocation()
//            }
//        }
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView(viewModel: ExploreViewModel())
    }
}
