//
//  BottomBarView.swift
//  klipboard
//
//  Created by Markiyan Kmit on 07/05/25.
//

import SwiftUI
import SwiftData

public struct BottomBarView: View {
    @Environment(\.modelContext) private var ctx
    @Query(sort: \ClipboardItem.createdAt, order: .reverse) private var items: [ClipboardItem]

    var showCopiedMessage: Bool
    public var body: some View {
        HStack {
            // TODO: title
            if showCopiedMessage {
                Text("Copied item to clipboard")
                    .frame(alignment: .leading)
            } else {
                Text(items.count == 1 ? "1 item copied" : "\(items.count) items copied")
                    .frame(alignment: .leading)
            }
            
            Spacer()
            
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
            .buttonStyle(.plain)
            // TODO: show
            .accessibilityLabel("Delete all items")
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 8)
        .padding(.horizontal, 16)
    }
}
