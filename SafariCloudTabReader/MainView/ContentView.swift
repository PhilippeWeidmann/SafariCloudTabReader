//
//  ContentView.swift
//  SafariCloudTabReader
//
//  Created by Philippe Weidmann on 26.10.2023.
//

import SafariCloudReaderKit
import SwiftUI

struct ContentView: View {
    var body: some View {
        if SafariCloudTabReader.shared.canFetchTabs() {
            PreferencesView()
        } else {
            RequestTabAccessView()
        }
    }
}

#Preview {
    ContentView()
}
