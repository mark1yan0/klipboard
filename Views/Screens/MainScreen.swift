//
//  ContentView.swift
//  klipboard
//
//  Created by Markiyan Kmit on 25/04/25.
//

import SwiftUI

struct MainScreen: View {
    
    var body: some View {
        ClipboardView()
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .modelContainer(for: [ClipboardItem.self])
    }
}
