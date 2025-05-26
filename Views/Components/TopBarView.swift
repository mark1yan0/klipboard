//
//  TopBarView.swift
//  klipboard
//
//  Created by Markiyan Kmit on 26/05/25.
//

import SwiftUI
import SwiftData

public struct TopBarView: View {
    public var body: some View {
        HStack {
            Spacer()
            Button(action: {
                NSApp.terminate(nil)
            }) {
                Image(systemName: "power")
            }
            .buttonStyle(.plain)
            // TODO: show
            .accessibilityLabel("Quit")
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
    }
}
