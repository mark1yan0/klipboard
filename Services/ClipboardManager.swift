//
//  ClipboardManager.swift
//  klipboard
//
//  Created by Markiyan Kmit on 25/04/25.
//

import Foundation
import SwiftUI
import AppKit

class ClipboardManager: ObservableObject {
    @Published var copied: [String] = []
    private var changedCount = NSPasteboard.general.changeCount
    
    private var timer: Timer?

    init() {
        monitorEvents()
    }
    
    private func monitorEvents() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.clipboardListener()
        }

    }
    
    // TODO: implement images
    private func clipboardListener() {
        let pasteboard = NSPasteboard.general
        
        guard pasteboard.changeCount != changedCount else {
            return
        }
    
        changedCount = pasteboard.changeCount
        if let newText = pasteboard.string(forType: .string) {
            
            guard !self.copied.contains(newText) else {
                // do not allow duplcates
                return
            }
            
            DispatchQueue.main.async {
                self.copied.insert(newText, at: 0)
            }
        }
    }
    
    // TODO: implement images
    // TODO: create interface for the item
    public func copy(item: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
        pasteboard.setString(item, forType: .string)
    }
    
    public func remove(item: String) {
        if let index = copied.firstIndex(of: item) {
            copied.remove(at: index)
        }
    }
    
    deinit {
        timer?.invalidate()
    }
}
