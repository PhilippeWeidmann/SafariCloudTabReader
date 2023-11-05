//
//  Device.swift
//
//
//  Created by Philippe Weidmann on 04.11.2023.
//

import Foundation

public struct Device: Codable, Identifiable {
    public let id: String
    public let name: String
    public var tabs = [SafariTab]()
}
