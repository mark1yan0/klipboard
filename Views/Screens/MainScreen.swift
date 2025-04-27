//
//  ContentView.swift
//  klipboard
//
//  Created by Markiyan Kmit on 25/04/25.
//

import SwiftUI

struct MainScreen: View {
    
    @StateObject private var clipboardManager = ClipboardManager()
    
    var body: some View {
        VStack {
            List {
                ForEach(clipboardManager.copied) {
                    item in HStack() {
                        VStack {
                            Text(item.text())
                            // TODO: format
                            Text("CreatedAt: \(item.date())")
                        }
                        Button("Copy") {
                            clipboardManager.copy(item: item.text())
                        }
                        Button("Delete") {
                            clipboardManager.remove(item: item)
                        }
                    }
                }
            }
        }
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    }
}

#Preview {
    MainScreen()
}

