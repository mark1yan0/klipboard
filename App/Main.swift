//
//  klipboardApp.swift
//  klipboard
//
//  Created by Markiyan Kmit on 25/04/25.
//

import SwiftUI

@main
struct main: App {
    var body: some Scene {
        MenuBarExtra("Klipboard", systemImage: "clipboard") {
            MainScreen()
                .frame(width: 450, height: 700)
        }
        .menuBarExtraStyle(.window)
    }
}

#Preview {
    MainScreen()
}
