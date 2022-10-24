//
//  FeedView.swift
//  BetterBe
//
//  Created by John Critchlow on 10/20/22.
//

import SwiftUI

struct FeedView: View {
    @State private var selectedFilter: FeedFilterViewModel = .friends
    @Environment(\.presentationMode) var mode
    @Namespace var animation
    
    var body: some View {
        VStack {
            FeedFilterBar
            
            ScrollView {
                LazyVStack {
                    ForEach(0...20, id: \.self) { _ in
                        EventsRowView()
                    }
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
