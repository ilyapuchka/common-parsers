// swift-tools-version:5.0
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
        .package(url: "https://github.com/pointfreeco/swift-prelude.git", .revision("9240a1f951c382e1c7387762c6cd94042baba531"))
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
