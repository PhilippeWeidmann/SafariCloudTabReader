//
//  PreferencesView.swift
//  SafariCloudTabReader
//
//  Created by Philippe Weidmann on 02.11.2023.
//

import SwiftUI
import SafariCloudReaderKit

struct PreferencesView: View {
    @AppStorage(Constants.enableChromiumExtensionServerKey) private var tabServerEnabled = true
    @AppStorage(Constants.enableMenuBarIconKey) private var enableMenuBarIcon = true

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.icloud.fill")
                .font(.system(size: 72))
                .foregroundStyle(.tint)

            VStack(alignment: .leading, spacing: 8) {
                Toggle("Enable Chromium Extension Server", isOn: $tabServerEnabled)
                if #available(macOS 13.0, *) {
                    Toggle("Enable Menu Bar Item", isOn: $enableMenuBarIcon)
                }
            }
        }
        .padding()
        .onAppear {
            SafariTabServer.shared.start()
        }
    }
}

#Preview {
    PreferencesView()
}
