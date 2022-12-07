//
//  FeedView.swift
//  Waddle
//
//  Created by John Critchlow on 10/20/22.
//

import SwiftUI
import RefreshableScrollView

struct FeedView: View {
    @State private var selectedFilter: FeedFilterViewModel = .friends
    @State private var showNewEventView: Bool = false
    @State var needsRefresh: Bool = false
    @ObservedObject var viewModel = FeedViewModel()
    @Environment(\.presentationMode) var mode
    @Namespace var animation
    
    var body: some View {
        VStack {
            FeedFilterBar
            
            ZStack(alignment: .bottomTrailing) {
                RefreshableScrollView {
                    LazyVStack {
                        ForEach(viewModel.events(forFilter: self.selectedFilter)) { event in
                            EventsRowView(event: event, needsRefresh: $needsRefresh)
                        }
                    }
                }
                .refreshable {
                      do {
                        // Sleep for 1 seconds
                        try await Task.sleep(nanoseconds: 1 * 1_000_000_000)
                      } catch {}
                      
                    viewModel.fetchEvents()
                    }
                
                Button {
                    showNewEventView.toggle()
                } label: {
                    Image(systemName: "plus")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 28, height: 28)
                        .padding()
                }
                .background(Color(.systemBlue))
                .foregroundColor(.white)
                .clipShape(Circle())
                .padding()
                .fullScreenCover(isPresented: $showNewEventView, onDismiss: refreshView) {
                    NewEventView()
                }
            }
        }
        .onChange(of: needsRefresh) { _ in
            refreshView()
        }
    }
    
    private func refreshView() {
        viewModel.fetchEvents()
        needsRefresh = false
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}

extension FeedView {
    var FeedFilterBar: some View {
        HStack {
            ForEach(FeedFilterViewModel.allCases, id: \.rawValue) { item in
                VStack {
                    Text(item.title)
                        .font(.subheadline)
                        .fontWeight(selectedFilter == item ? .semibold : .regular)
                        .foregroundColor(selectedFilter == item ? .black : .gray)
                    
                    if selectedFilter == item {
                        Capsule()
                            .foregroundColor(Color(.systemBlue))
                            .frame(height: 3)
                            .matchedGeometryEffect(id: "filter", in: animation)
                    } else {
                        Capsule()
                            .foregroundColor(Color(.clear))
                            .frame(height: 3)
                    }
                }
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        self.selectedFilter = item
                    }
                }
            }
        }
        .overlay(Divider().offset(x: 0, y: 16))
    }
}
