// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "hedgehog",
    platforms: [
        .macOS(.v10_15)
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.0.1")
    ],
    targets: [
        .target(
            name: "hedgehog",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ])
    ]
)
