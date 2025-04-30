//
//  ClipboardView.swift
//  klipboard
//
//  Created by Markiyan Kmit on 27/04/25.
//

import SwiftUI
import SwiftData

struct ClipboardView: View {
    @Environment(\.modelContext) private var ctx
    @State private var changedCount = NSPasteboard.general.changeCount
    @State private var timer: Timer?
    
    // TODO: add scroll to top
    private func monitorEvents() {
        // TODO: solve this firing multiple times
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            let pasteboard = NSPasteboard.general
            
            guard pasteboard.changeCount != changedCount else {
                return
            }
            
            changedCount = pasteboard.changeCount
            if let newText = pasteboard.string(forType: .string) {
                guard !items.contains(where: { $0.body == newText } ) else {
                   // do not allow duplcates
                    return
                }
                
                DispatchQueue.main.async {
                    ctx.insert(ClipboardItem(newText))
                    try? ctx.save()
                }
            }
        }
    }
    
    // UI

    // TODO: make copy on enter
    @State private var selectedItem: ClipboardItem.ID?
    @Query(sort: \ClipboardItem.createdAt, order: .reverse) private var items: [ClipboardItem]
    var body: some View {
        VStack {
            List(selection: $selectedItem) {
                ForEach(items) { item in
                    ClipboardRow(item: item, selectedItem: selectedItem)
                    .padding(8)
                    .background(Color.black.opacity(0.2))
                    .cornerRadius(8)
                    .listRowSeparator(.hidden, edges: .bottom)
                }
            }
        }
        .toolbar {
            // TODO: title
            Text(items.count == 1 ? "1 item copied" : "\(items.count) items copied")
            Button(action: {
                // TODO: show dialog
                do {
                    try ctx.delete(model: ClipboardItem.self)
                    try ctx.save()
                } catch {
                    // TODO: more safety (error hanling)
                    print("Failed to delete items")
                }
            }) {
                Image(systemName: "trash")
            }
            // TODO: show
            .accessibilityLabel("Delete all items")
        }
        .onAppear {
            monitorEvents()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
}

func copyHandler(_ content: String) {
    let pasteboard = NSPasteboard.general
    pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
    pasteboard.setString(content, forType: .string)
}

struct ClipboardRow: View {
    @Environment(\.modelContext) private var ctx
    let item: ClipboardItem
    let selectedItem: ClipboardItem.ID?
    var body: some View {
        HStack {
            Image(systemName: "textbox")
            Text(item.body)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Button(action: {
                // will become double click
                copyHandler(item.body)
            }) {
                Image(systemName: "document.on.document")
            }
            .buttonStyle(.plain)
            // TODO: hover style
            Button(action: {
                do {
                    ctx.delete(item)
                    try ctx.save()
                } catch {
                    // TODO: more safety (error hanling)
                    print("Failed to delete item.")
                }
            }) {
                Image(systemName: "trash")
            }
            .buttonStyle(.plain)
            .padding(.leading, 8)
            // TODO: hover style
        }
        .tag(item.id)
        // TODO: make copy on enter
    }
}

