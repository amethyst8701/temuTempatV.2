//
//  SearchBarView.swift
//  NavMap
//
//  Created by Cynthia Shabrina on 08/05/25.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    let onSubmit: (() -> Void)?

    init(searchText: Binding<String>, onSubmit: (() -> Void)? = nil) {
        self._searchText = searchText
        self.onSubmit = onSubmit
    }

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Places, Building, Tags", text: $searchText)
                .textFieldStyle(.plain)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .submitLabel(.search)
                .onSubmit {
                    onSubmit?()
                }
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(10)
        .background(Color(.white))
        .frame(width: 280)
        .cornerRadius(10)
        .padding(.horizontal)
        .shadow(radius: 1)
    }
}

#Preview {
    StatefulPreviewWrapper("") { binding in 
        SearchBarView(searchText: binding)
    }
}

// Utility untuk membuat preview binding
struct StatefulPreviewWrapper<Value>: View {
    @State var value: Value
    var content: (Binding<Value>) -> AnyView

    init(_ value: Value, content: @escaping (Binding<Value>) -> some View) {
        _value = State(initialValue: value)
        self.content = { binding in AnyView(content(binding)) }
    }

    var body: some View {
        content($value)
    }
}
