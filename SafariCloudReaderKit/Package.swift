// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SafariCloudReaderKit",
    platforms: [.macOS(.v11)],
    products: [
        .library(
            name: "SafariCloudReaderKit",
            targets: ["SafariCloudReaderKit"]
        ),
    ],
    dependencies: [.package(url: "https://github.com/httpswift/swifter.git", .upToNextMajor(from: "1.5.0")),
                   .package(url: "https://github.com/stephencelis/SQLite.swift.git", .upToNextMajor(from: "0.14.1"))],
    targets: [
        .target(name: "SafariCloudReaderKit", dependencies: [
            .product(name: "Swifter", package: "swifter"),
            .product(name: "SQLite", package: "SQLite.swift")
        ])
    ]
)
