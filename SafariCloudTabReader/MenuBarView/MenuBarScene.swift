//
//  MenuBarScene.swift
//  SafariCloudTabReader
//
//  Created by Philippe Weidmann on 02.11.2023.
//

import SafariCloudReaderKit
import SwiftUI

@available(macOS 13.0, *)
struct MenuBarScene: Scene {
    @AppStorage(Constants.enableMenuBarIconKey) private var enableMenuBarIcon = true

    var body: some Scene {
        MenuBarExtra(
            "SafariCloudTabReader",
            systemImage: "link.icloud.fill",
            isInserted: $enableMenuBarIcon
        ) {
            TabList()
        }
        .menuBarExtraStyle(.window)
    }
}
