//
//  CliboardItem.swift
//  klipboard
//
//  Created by Markiyan Kmit on 27/04/25.
//

import Foundation
import SwiftData

@Model
class ClipboardItem: Identifiable {
    @Attribute(.unique) var id: UUID
    @Attribute var createdAt: Date
    @Attribute var body: String // TODO: handle images
    
    
    init(_ text: String) {
        self.id = UUID()
        self.body = text.trimmingCharacters(in: .whitespacesAndNewlines)
        // TODO: look at how saved to db
        self.createdAt = Date()
    }
}
