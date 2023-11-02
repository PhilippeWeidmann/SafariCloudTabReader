//
//  SafariCloudTabReader.swift
//  SafariCloudTabReader
//
//  Created by Philippe Weidmann on 26.10.2023.
//

import Foundation
import SQLite

public class SafariCloudTabReader {
    public lazy var cloudTabsURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first?
        .appendingPathComponent("Containers/com.apple.Safari/Data/Library/Safari/CloudTabs.db")

    enum SafariCloudTabReaderError: Error {
        case noPath
    }
    
    public init() {}

    public func readDB() throws {
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
        print(temporaryWorkingPath)

        let db = try Connection(temporaryWorkingPath)

        let cloudTabs = Table("cloud_tabs")
        let title = Expression<String>("title")
        let url = Expression<String>("url")

        for tab in try db.prepare(cloudTabs) {
            print(tab[title], tab[url])
        }
    }
}
