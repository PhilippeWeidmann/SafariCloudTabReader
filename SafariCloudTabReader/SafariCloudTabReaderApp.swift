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
        Settings {
            ContentView()
        }

        if #available(macOS 13.0, *) {
            MenuBarScene()
        }
    }
}
