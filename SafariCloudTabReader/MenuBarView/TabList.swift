//
//  TabList.swift
//  SafariCloudTabReader
//
//  Created by Philippe Weidmann on 02.11.2023.
//

import SafariCloudReaderKit
import SwiftUI

struct TabList: View {
    @State private var windowObserver: NSKeyValueObservation?
    @State private var tabsPerDevice: [Device]?
    @State private var estimatedHeight: CGFloat = 32
    @State private var loadingError: Error?

    var body: some View {
        List {
            if SafariCloudTabReader.shared.canFetchTabs() {
                if let tabsPerDevice {
                    ForEach(tabsPerDevice) { device in
                        Section {
                            ForEach(device.tabs.filter { $0.url != nil }) { tab in
                                TabRowView(tab: tab)
                            }
                        } header: {
                            HStack {
                                Text(device.name)
                                if tabsPerDevice.firstIndex(where: { $0.id == device.id }) == 0 {
                                    Spacer()

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
                        }
                    }
                } else {
                    Text("Fetching tabs")
                }
            } else {
                Text("Cannot fetch tabs")
            }
        }
        .listStyle(.sidebar)
        .frame(width: 400, height: estimatedHeight)
        .onAppear {
            windowObserver = NSApplication.shared.observe(\.keyWindow) { x, y in
                guard NSApplication.shared.keyWindow != nil else { return }
                Task {
                    await loadTabs()
                }
            }
        }
    }

    func loadTabs() async {
        do {
            SafariXPCConnector.shared.xpcFetchCloudTabDevicesAndCloseRequests()
            let tabsPerDevice = try await SafariCloudTabReader.shared.fetchTabsPerDevice()
            self.tabsPerDevice = tabsPerDevice
            let allTabsCount = tabsPerDevice
                .map { $0.tabs.filter { $0.url != nil }.count }
                .reduce(0) { x, y in
                    x + y
                }
            estimatedHeight = CGFloat(16 * tabsPerDevice.count + 32 * allTabsCount) + 24
        } catch {
            loadingError = error
        }
    }
}
