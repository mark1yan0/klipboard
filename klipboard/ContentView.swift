//
//  ContentView.swift
//  klipboard
//
//  Created by Markiyan Kmit on 25/04/25.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var clipboardManager = ClipboardManager()
    
    var body: some View {
        VStack {
            List(clipboardManager.copied, id: \.self) {
                item in HStack() {
                    Text(item)
                    Button("Copy") {
                        clipboardManager.copy(item: item)
                    }
                    Button("Delete") {
                        clipboardManager.remove(item: item)
                    }
                }
            }
        }
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    }
}

#Preview {
    ContentView()
}
