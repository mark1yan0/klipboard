//
//  ClipboardManager.swift
//  klipboard
//
//  Created by Markiyan Kmit on 25/04/25.
//

import Foundation
import SwiftUI
import SwiftData
import AppKit

// TODO: see if view can be refactored

class ClipboardManager: ObservableObject {
    private var ctx: ModelContext?
    @Published private var copied: [ClipboardItem] = []
    private var changedCount = NSPasteboard.general.changeCount
    
//    public var mock = [
//        ClipboardItem(text: "mock 1"),
//        ClipboardItem(text: "mock 2"),
//        ClipboardItem(text: "mock 3"),
//    ]


    private var timer: Timer?

     init() {
         monitorEvents()
     }
    
    func setCtx(_ ctx: ModelContext) {
        self.ctx = ctx
    }
    
    func loadItems() {
        guard let ctx else {
            return
        }
        
        let descriptor = FetchDescriptor<ClipboardItem>()
        copied = (try? ctx.fetch(descriptor)) ?? []
    }
    
    // for testing, should be automatic
    func insert(_ text: String) {
        guard let ctx else {
            return
        }
        
        let item = ClipboardItem(text)
        ctx.insert(item)
        try? ctx.save()
        loadItems()
    }
    
    func delete(_ item: ClipboardItem) {
        guard let ctx else {
            return
        }
        
        ctx.delete(item)
        try? ctx.save()
        loadItems()
    }
    
    private func monitorEvents() {
//        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
//            self.clipboardListener()
//        }

    }
    
    // TODO: implement images
    private func clipboardListener() {
        let pasteboard = NSPasteboard.general
        
        guard pasteboard.changeCount != changedCount else {
            return
        }
    
        changedCount = pasteboard.changeCount
        if let newText = pasteboard.string(forType: .string) {
            // TODO: by id
//            guard !self.copied.contains(where: { $0.text() == newText } ) else {
//               // do not allow duplcates
//                return
//            }
            
            DispatchQueue.main.async {
//                self.ctx.insert(ClipboardItem(text: newText))
                self.copied.append(ClipboardItem(newText))
            }
        }
    }
    
    // Called only after the model context is available
    public func initialize() {
        // This function can be called from your view's onAppear or similar.
        monitorEvents()
    }
    
    public func items() -> [ClipboardItem] {
        return copied
    }
    
    // TODO: implement images
    // TODO: create interface for the item
    public func copy(item: String) -> Void {
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
        pasteboard.setString(item, forType: .string)
    }
    
    public func delete(item: ClipboardItem) -> Void {
//        self.ctx.delete(item)
        self.copied.remove(at: self.copied.firstIndex(of: item)!)
    }
    
    public func destory() -> Void {
        timer?.invalidate()
    }
}
