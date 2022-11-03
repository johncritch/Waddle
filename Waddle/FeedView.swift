//
//  FeedView.swift
//  Waddle
//
//  Created by John Critchlow on 10/20/22.
//

import SwiftUI

struct FeedView: View {
    @State private var selectedFilter: FeedFilterViewModel = .friends
    @State private var showNewEventView: Bool = false
    @ObservedObject var viewModel = FeedViewModel()
    @Environment(\.presentationMode) var mode
    @Namespace var animation
    
    var body: some View {
        VStack {
            FeedFilterBar
            
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.events) { event in
                            EventsRowView(event: event)
                        }
                    }
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
                .fullScreenCover(isPresented: $showNewEventView) {
                    NewEventView()
                }
            }
        }
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
