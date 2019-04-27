// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CommonParsers",
    products: [
        .library(
            name: "CommonParsers",
            targets: ["CommonParsers"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-prelude.git", .branch("master"))
    ],
    targets: [
        .target(
            name: "CommonParsers",
            dependencies: ["Prelude"]),
        .testTarget(
            name: "CommonParsersTests",
            dependencies: ["CommonParsers"]),
    ]
)
