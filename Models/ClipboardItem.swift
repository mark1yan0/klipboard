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
    
    
    init(_ content: String) {
        self.id = UUID()
        self.body = content.trimmingCharacters(in: .whitespacesAndNewlines)
        self.createdAt = Date()
    }
}
