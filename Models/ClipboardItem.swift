//
//  CliboardItem.swift
//  klipboard
//
//  Created by Markiyan Kmit on 27/04/25.
//

import Foundation
import SwiftData

public struct ClipboardItem: Identifiable {
    public let id: UUID
    private let createdAt: Date
    private let copiedText: String // TODO: handle images
    
    
    init(text: String) {
        self.id = UUID()
        self.copiedText = text
        self.createdAt = Date()
    }
    
    public func text() -> String {
        return copiedText
    }
    
    public func date() -> Date {
        return createdAt
    }
}
