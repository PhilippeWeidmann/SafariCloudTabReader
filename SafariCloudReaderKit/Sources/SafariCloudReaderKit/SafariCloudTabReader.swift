//
//  SafariCloudTabReader.swift
//  SafariCloudTabReader
//
//  Created by Philippe Weidmann on 26.10.2023.
//

import Foundation
import SQLite

public class SafariCloudTabReader {
    public static let shared = SafariCloudTabReader()

    public lazy var cloudTabsURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first?
        .appendingPathComponent("Containers/com.apple.Safari/Data/Library/Safari/CloudTabs.db")

    enum SafariCloudTabReaderError: Error {
        case noPath
    }

    private init() {}

    public func canFetchTabs() -> Bool {
        guard let cloudTabsPath = cloudTabsURL?.path else { return false }

        return FileManager.default.isReadableFile(atPath: cloudTabsPath)
    }

    public func fetchTabsPerDevice() async throws -> [Device] {
        return try blockingFetchTabsPerDevice()
    }

    public func blockingFetchTabsPerDevice() throws -> [Device] {
        guard let cloudTabsPath = cloudTabsURL?.path else { throw SafariCloudTabReaderError.noPath }

        let temporaryWorkingDirectoryPath = FileManager.default.temporaryDirectory.appendingPathComponent("SafariCloudTabReader")
            .path
        let temporaryWorkingPath = FileManager.default.temporaryDirectory
            .appendingPathComponent("SafariCloudTabReader/CloudTabs.db").path

        if FileManager.default.fileExists(atPath: temporaryWorkingDirectoryPath) {
            try FileManager.default.removeItem(atPath: temporaryWorkingDirectoryPath)
        }
        try FileManager.default.createDirectory(atPath: temporaryWorkingDirectoryPath, withIntermediateDirectories: true)
        try FileManager.default.copyItem(atPath: cloudTabsPath, toPath: temporaryWorkingPath)

        let db = try Connection(temporaryWorkingPath)

        let devices = try fetchDevices(db: db)
        let tabsPerDevice = try fetchTabs(db: db, devices: devices)

        return tabsPerDevice.filter { !$0.tabs.isEmpty }
    }

    private func fetchDevices(db: Connection) throws -> [Device] {
        let devices = Table("cloud_tab_devices")
        let deviceUuid = Expression<String>("device_uuid")
        let deviceName = Expression<String>("device_name")
        return try db.prepare(devices).map { Device(id: $0[deviceUuid], name: $0[deviceName]) }
    }

    private func fetchTabs(db: Connection, devices: [Device]) throws -> [Device] {
        var devices = devices
        let cloudTabs = Table("cloud_tabs")
        let tabUuid = Expression<String>("tab_uuid")
        let deviceUuid = Expression<String>("device_uuid")
        let title = Expression<String>("title")
        let url = Expression<String>("url")

        for tab in try db.prepare(cloudTabs) {
            let safariTab = SafariTab(id: tab[tabUuid], title: tab[title], rawURL: tab[url])
            guard let existingDeviceIndex = devices.firstIndex(where: { $0.id == tab[deviceUuid] }) else {
                continue
            }
            devices[existingDeviceIndex].tabs.append(safariTab)
        }
        return devices
    }
}
