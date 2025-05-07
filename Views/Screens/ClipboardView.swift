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
            monitorEvents()
        }
        .onDisappear {
            timer?.invalidate()
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
