// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftGeneratePasswords",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "SwiftGeneratePasswords",
            targets: ["SwiftGeneratePasswords"]),
    ],
    targets: [
        .target(
            name: "SwiftGeneratePasswords"),
        .testTarget(
            name: "SwiftGeneratePasswordsTests",
            dependencies: ["SwiftGeneratePasswords"]),
    ]
)
