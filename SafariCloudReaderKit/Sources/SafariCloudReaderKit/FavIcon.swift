//
//  FavIcon.swift
//
//
//  Created by Philippe Weidmann on 02.11.2023.
//

import Foundation

// Thanks https://stackoverflow.com/questions/39802384/extracting-ios-favicon-from-any-website
public struct FavIcon {
    public enum Size: Int, CaseIterable { case s = 16, m = 32, l = 64, xl = 128, xxl = 256, xxxl = 512 }
    private let domain: String
    init(_ domain: String) { self.domain = domain }
    public subscript(_ size: Size) -> URL? {
        URL(string: "https://www.google.com/s2/favicons?sz=\(size.rawValue)&domain=\(domain)")
    }
}
