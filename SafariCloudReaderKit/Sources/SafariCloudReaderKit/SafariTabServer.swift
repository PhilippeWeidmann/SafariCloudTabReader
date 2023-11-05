//
//  SafariTabServer.swift
//
//
//  Created by Philippe Weidmann on 02.11.2023.
//

import Foundation
import Swifter

public class SafariTabServer {
    public static let shared = SafariTabServer()

    private let server = HttpServer()
    private static let encoder = JSONEncoder()
    private init() {
        server["/tabs"] = { _ in
            do {
                SafariXPCConnector.shared.xpcFetchCloudTabDevicesAndCloseRequests()
                let tabs = try SafariCloudTabReader.shared.blockingFetchTabsPerDevice()
                let encodedTabsResponse = try SafariTabServer.encoder.encode(tabs)
                return .ok(.data(encodedTabsResponse, contentType: "application/json"))
            } catch {
                return .internalServerError
            }
        }
    }

    public func start() {
        guard !server.operating else { return }
        do {
            try server.start(7474)
        } catch {
            print(error)
        }
    }
}
