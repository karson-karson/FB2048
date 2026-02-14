// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FB2048",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "FB2048",
            targets: ["FB2048"]
        )
    ],
    targets: [
        .target(
            name: "FB2048",
            path: "Sources/FB2048"
        )
    ]
)
