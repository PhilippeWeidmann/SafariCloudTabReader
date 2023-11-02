//
//  SafariCloudTabReaderApp.swift
//  SafariCloudTabReader
//
//  Created by Philippe Weidmann on 26.10.2023.
//

import SwiftUI

@main
struct SafariCloudTabReaderApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        if #available(macOS 13.0, *) {
            MenuBarExtra(
                "SafariCloudTabReader",
                systemImage: "link.icloud.fill",
                isInserted: .constant(true)
            ) {
                Text("")
                    .frame(width: 300, height: 400)
            }
            .menuBarExtraStyle(.window)
        }
    }
}
