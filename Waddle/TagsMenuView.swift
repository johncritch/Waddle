//
//  TagsMenuView.swift
//  Waddle
//
//  Created by John Critchlow on 11/8/22.
//

import SwiftUI

struct TagsMenuView: View {
    @Binding var tags: [Tag]
    @State var selectedTags = [Tag]()
    
    @ObservedObject var viewModel = TagsMenuViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(selectedTags, id: \.id) { tag in
                        TagView(selectedTags: $selectedTags, tag: tag, doesChangeColor: false)
                    }
                    Spacer()
                }
                .padding(.leading)
            }
            SearchBar(text: $viewModel.searchText)
                .padding(.horizontal)
            ScrollView {
                LazyVStack(alignment: .leading) {
                    if viewModel.searchText == "" {
                        Text("Popular Tags:")
                            .font(.headline)
                        ForEach(viewModel.popularTags, id: \.id) { tag in
                            TagView(selectedTags: $selectedTags, tag: tag)
                        }
                        Text("All Tags:")
                            .font(.headline)
                    } else {
                        Text("Showing results for '\(viewModel.searchText)'")
                    }
                    ForEach(viewModel.searchableTags, id: \.id) { tag in
                        TagView(selectedTags: $selectedTags, tag: tag)
                    }
                }
                .padding(.leading)
            }
            Spacer()
        }
        .padding(.top)
        .onAppear {
            selectedTags = tags
        }
        .onDisappear {
            tags = selectedTags
        }
    }
}

struct TagsMenuView_Previews: PreviewProvider {
    static var previews: some View {
        TagsMenuView(tags: .constant([Tag]()))
    }
}
