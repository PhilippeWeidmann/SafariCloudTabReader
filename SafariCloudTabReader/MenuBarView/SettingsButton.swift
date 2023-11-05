//
//  SettingsButton.swift
//  SafariCloudTabReader
//
//  Created by Philippe Weidmann on 05.11.2023.
//

import SwiftUI

struct SettingsButton: View {
    var body: some View {
        Group {
            if #available(macOS 14.0, *) {
                SettingsLink {
                    Label("Preferences", systemImage: "gear")
                }
            } else {
                Button("Preferences", systemImage: "gear") {
                    NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
                }
            }
        }
        .labelStyle(.iconOnly)
        .buttonStyle(.plain)
    }
}

#Preview {
    SettingsButton()
}
