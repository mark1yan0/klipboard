//
//  ClipboardManager.swift
//  klipboard
//
//  Created by Markiyan Kmit on 26/05/25.
//
import Foundation
import SwiftData
import AppKit

// TODO: rename folder
@Observable
class ClipboardMonitor {
    private var timer: Timer?
    private var changedCount = NSPasteboard.general.changeCount
    private let ctx: ModelContext

    init(ctx: ModelContext) {
        self.ctx = ctx
        start()
    }

    private func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.checkClipboard()
        }
    }

    private func checkClipboard() {
        let pasteboard = NSPasteboard.general

        guard pasteboard.changeCount != changedCount else {
            return
        }
        
        changedCount = pasteboard.changeCount
        

        if let newText = pasteboard.string(forType: .string) {
            // check if already exists
            // TODO: solve duplicate items on multiple lines
            let descriptor = FetchDescriptor<ClipboardItem>(
                predicate: #Predicate { $0.body == newText }
            )
            let exists = (try? ctx.fetch(descriptor).isEmpty == false) ?? false
            if !exists {
                ctx.insert(ClipboardItem(newText))
                try? ctx.save()
            }
        }
    }

    deinit {
        timer?.invalidate()
    }
}
