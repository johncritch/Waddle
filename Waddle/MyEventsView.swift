//
//  NotificationsView.swift
//  Waddle
//
//  Created by John Critchlow on 10/20/22.
//

import SwiftUI
import RefreshableScrollView

struct MyEventsView: View {
    @ObservedObject var viewModel: MyEventsViewModel
    
    init() {
        self.viewModel = MyEventsViewModel()
    }
    
    var body: some View {
        RefreshableScrollView {
            LazyVStack {
                ForEach(viewModel.joinedEvents) { event in
                    ReducedEventsRowView(event: event)
                }
            }
        }
        .refreshable {
              do {
                // Sleep for 1 seconds
                try await Task.sleep(nanoseconds: 1 * 1_000_000_000)
              } catch {}
              
            viewModel.fetchJoinedEvents()
        }
    }
}

struct MyEventsView_Previews: PreviewProvider {
    static var previews: some View {
        MyEventsView()
    }
}
