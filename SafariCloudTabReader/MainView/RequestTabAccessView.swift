//
//  RequestTabAccessView.swift
//  SafariCloudTabReader
//
//  Created by Philippe Weidmann on 02.11.2023.
//

import SwiftUI
import SafariCloudReaderKit

struct RequestTabAccessView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "lock.icloud")
                .font(.system(size: 72))
                .foregroundStyle(.tint)
            Text("Permission required")
                .font(.title)

            Text("We need permission to access to your tabs")
            Button("Grant access to tabs") {
                let panel = NSOpenPanel()
                panel.directoryURL = SafariCloudTabReader.shared.cloudTabsURL
                panel.allowsMultipleSelection = false
                panel.canChooseDirectories = true
                if panel.runModal() == .OK {}
            }
        }
        .padding()
    }
}

#Preview {
    RequestTabAccessView()
}
