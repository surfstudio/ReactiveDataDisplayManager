// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ReactiveDataComponents",
    platforms: [.iOS(.v11)],
    products: [
        .library(
            name: "ReactiveDataComponents",
            targets: ["ReactiveDataComponents"]
        )
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "ReactiveDataComponents"
        )
    ]
)
