//
//  SafariTab.swift
//
//
//  Created by Philippe Weidmann on 02.11.2023.
//

import Foundation

public struct SafariTab: Codable, Identifiable {
    public let id: String
    public let title: String
    public let rawURL: String

    public var url: URL? {
        return URL(string: rawURL)
    }

    public var favIcon: FavIcon? {
        guard let host = url?.host else { return nil }
        return FavIcon(host)
    }
}
