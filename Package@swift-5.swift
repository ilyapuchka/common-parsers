// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "common-parsers",
    products: [
        .library(
            name: "common-parsers",
            targets: ["common-parsers"]),
        ],
    dependencies: [
        .package(url: "https://github.com/ilyapuchka/swift-prelude.git", .branch("master"))
    ],
    targets: [
        .target(
            name: "common-parsers",
            dependencies: []),
        .testTarget(
            name: "common-parsersTests",
            dependencies: ["common-parsers"]),
        ]
)

