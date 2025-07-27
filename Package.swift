// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-generate-passwords",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "PasswordGenerator",
            targets: ["PasswordGenerator"]),
    ],
    targets: [
        .target(
            name: "PasswordGenerator"),
        .testTarget(
            name: "PasswordGeneratorTests",
            dependencies: ["PasswordGenerator"]),
    ]
)
