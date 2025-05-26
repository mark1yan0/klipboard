//
//  ClipboardView.swift
//  klipboard
//
//  Created by Markiyan Kmit on 27/04/25.
//

import SwiftUI
import SwiftData

struct ClipboardView: View {
    @State private var monitor: ClipboardMonitor?
    @Environment(\.modelContext) private var ctx

    @State private var showCopiedMessage: Bool = false
    func flashOnCopy() {
        withAnimation {
            showCopiedMessage = true
        }
        // remove after timeout
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                showCopiedMessage = false
            }
        }
    }
    
    // UI
    @Query(sort: \ClipboardItem.createdAt, order: .reverse) private var items: [ClipboardItem]
    var body: some View {
        VStack {
            List {
                ForEach(items) { item in
                    ClipboardRowView(item: item) {
                        flashOnCopy()
                    }
                    .listRowSeparator(.hidden, edges: .bottom)
                }
            }
        }
        .onAppear {
            if monitor == nil {
                monitor = ClipboardMonitor(ctx: ctx)
            }
        }
        
        BottomBarView(showCopiedMessage: showCopiedMessage)
            .padding(2)
    }
}

func copyHandler(_ content: String) {
    let pasteboard = NSPasteboard.general
    pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
    pasteboard.setString(content, forType: .string)
}
