//
//  ClipboardRowView.swift
//  klipboard
//
//  Created by Markiyan Kmit on 07/05/25.
//

import SwiftUI


// TODO: make copy on enter
struct ClipboardRowView: View {
    @Environment(\.modelContext) private var ctx
    let item: ClipboardItem
    var onCopy: () -> Void
    var body: some View {
        HStack {
            Button(action: {
                copyHandler(item.body)
                onCopy()
            }) {
                HStack {
                    Image(systemName: "textbox")
                    Text(item.body)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity)
                .padding(8)
                .background(Color.black.opacity(0.2))
                .cornerRadius(8)
                // make whole button clickable
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
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
        }
    }
}
