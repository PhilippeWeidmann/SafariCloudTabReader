//
//  SafariXPCConnector.swift
//  SafariCloudTabReader
//
//  Created by Philippe Weidmann on 03.11.2023.
//

import Foundation
import XPC

// Discovered using Hopper /System/Volumes/Preboot/Cryptexes/App/System/Library/CoreServices/SafariSupport.bundle/Contents/MacOS/SafariBookmarksSyncAgent
@objc protocol WBSSafariBookmarksSyncAgentProtocol {
    func fetchCloudTabDevicesAndCloseRequests()
}

public class SafariXPCConnector {
    public static let shared = SafariXPCConnector()
    private let connection: NSXPCConnection

    private init() {
        connection = NSXPCConnection(machServiceName: "com.apple.SafariBookmarksSyncAgent")

        connection.interruptionHandler = {
            print("interruptionHandler")
        }

        connection.invalidationHandler = {
            print("invalidationHandler")
        }

        connection.remoteObjectInterface = NSXPCInterface(with: WBSSafariBookmarksSyncAgentProtocol.self)
        connection.resume()
    }

    public func xpcFetchCloudTabDevicesAndCloseRequests() {
        guard let syncAgent = connection.remoteObjectProxy as? WBSSafariBookmarksSyncAgentProtocol else {
            print("Failed casting WBSSafariBookmarksSyncAgentProtocol")
            return
        }
        syncAgent.fetchCloudTabDevicesAndCloseRequests()
    }
}
