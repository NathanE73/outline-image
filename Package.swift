// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "ImageOutliner",
    products: [
        .executable(name: "image-outliner", targets: ["Main"]),
        ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.1.0")
    ],
    targets: [
        .target(
            name: "Main",
            dependencies: ["ImageOutliner"]),
        .target(
            name: "ImageOutliner",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ])
        ]
)
