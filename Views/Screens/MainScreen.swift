//
//  ContentView.swift
//  klipboard
//
//  Created by Markiyan Kmit on 25/04/25.
//

import SwiftUI

struct MainScreen: View {
    var body: some View {
        TopBarView()
        ClipboardView()
        .modelContainer(for: [ClipboardItem.self])
    }
}
