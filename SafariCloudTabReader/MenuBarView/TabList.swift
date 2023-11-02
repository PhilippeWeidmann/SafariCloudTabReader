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
    @State private var tabs: [SafariTab]?
    @State private var loadingError: Error?

    var body: some View {
        List {
            if SafariCloudTabReader.shared.canFetchTabs() {
                if let tabs {
                    ForEach(tabs) { tab in
                        TabRowView(tab: tab)
                    }
                } else {
                    Text("Fetching tabs")
                }
            } else {
                Text("Cannot fetch tabs")
            }
        }
        .listStyle(.plain)
        .frame(width: 400, height: CGFloat((tabs?.count ?? 1) * 28))
        .onAppear {
            windowObserver = NSApplication.shared.observe(\.keyWindow) { x, y in
                Task {
                    await loadTabs()
                }
            }
        }
    }

    func loadTabs() async {
        do {
            tabs = try await SafariCloudTabReader.shared.fetchTabs().filter { $0.url != nil }
        } catch {
            loadingError = error
        }
    }
}
