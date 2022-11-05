//
//  InputArea.swift
//  Waddle
//
//  Created by John Critchlow on 11/4/22.
//

import SwiftUI
import BlackLabsSwiftUIColor

struct InputArea: View {
    @Binding var text: String
    
    @FocusState private var keyboardFocused: Bool
    @State var inputName: String
    var body: some View {
        ZStack {
            TextField(inputName, text: $text)
                .focused($keyboardFocused)
                .padding(8)
                .padding(.horizontal, 16)
                .background(Color(.white))
                .cornerRadius(8)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        keyboardFocused = true
                    }
                }
        }
        .padding(.horizontal, 24)
        .shadow(radius: 4)
    }
}

struct InputArea_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            InputArea(text: .constant(""), inputName: "Title...")
        }
    }
}
