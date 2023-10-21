// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Meadow",
    platforms: [.macOS(.v11),
                .iOS(.v13)],
    products: [
        .library(
            name: "Meadow",
            targets: ["Meadow"]),
    ],
    dependencies: [
        .package(url: "git@github.com:nicklockwood/Euclid.git", branch: "main"),
        .package(path: "../Bivouac"),
    ],
    targets: [
        .target(
            name: "Meadow",
            dependencies: ["Bivouac", "Euclid"]),
    ]
)
