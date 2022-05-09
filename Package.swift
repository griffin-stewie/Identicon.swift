// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Identicon",
    platforms: [
        .macOS(.v11),
    ],
    products: [
        .executable(name: "identicon", targets: ["CLI"]),
        .library(name: "Identicon", targets: ["Identicon"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "1.1.2")),
        .package(url: "https://github.com/mxcl/Path.swift.git", .upToNextMinor(from: "1.4.0")),
        .package(url: "https://github.com/apple/swift-algorithms", from: "1.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "CLI",
            dependencies: [
                "Identicon",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Path", package: "Path.swift"),
			],
            path: "Sources/CLI"),
        .target(
            name: "Identicon",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms"),
            ]),
        .testTarget(
            name: "IdenticonTests",
            dependencies: ["Identicon"]),
    ]
)
