//
//  ContentView.swift
//  SafariCloudTabReader
//
//  Created by Philippe Weidmann on 26.10.2023.
//

import CloudKit
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button("Select File") {
                let panel = NSOpenPanel()
                panel.directoryURL = SafariCloudTabReader().cloudTabsURL
                panel.allowsMultipleSelection = false
                panel.canChooseDirectories = true
                if panel.runModal() == .OK {
                    let reader = SafariCloudTabReader()
                    do {
                        try reader.readDB()
                    } catch {
                        print(error)
                    }
                }
            }
        }
        .padding()
        .onAppear {
            let reader = SafariCloudTabReader()
            do {
                try reader.readDB()
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    ContentView()
}
