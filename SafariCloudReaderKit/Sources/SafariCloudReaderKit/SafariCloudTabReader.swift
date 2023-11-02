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

    public func fetchTabs() async throws -> [SafariTab] {
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

        let cloudTabs = Table("cloud_tabs")
        let uuid = Expression<String>("tab_uuid")
        let title = Expression<String>("title")
        let url = Expression<String>("url")

        return try db.prepare(cloudTabs).map { SafariTab(id: $0[uuid], title: $0[title], rawURL: $0[url]) }
    }
}
