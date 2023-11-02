//
//  TabRowView.swift
//  SafariCloudTabReader
//
//  Created by Philippe Weidmann on 02.11.2023.
//

import SafariCloudReaderKit
import SwiftUI

struct TabRowView: View {
    @Environment(\.openURL) private var openURL

    let tab: SafariTab
    var body: some View {
        Button {
            guard let url = tab.url else { return }
            openURL(url)
        } label: {
            HStack {
                AsyncImage(url: tab.favIcon?[.xl]) { favIcon in
                    favIcon
                        .resizable()
                        .frame(width: 16, height: 16)
                } placeholder: {
                    Image(systemName: "globe")
                        .resizable()
                        .frame(width: 16, height: 16)
                }

                Text(tab.title)
                    .lineLimit(1)
            }
            .padding(2)
        }
        .buttonStyle(.plain)
    }
}
