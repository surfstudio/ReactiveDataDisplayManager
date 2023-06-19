// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ReactiveDataComponents",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "ReactiveDataComponents",
            targets: ["ReactiveDataComponents"]
        )
    ],
    dependencies: [
        .package(name: "ReactiveDataDisplayManager", path: "../"),
        .package(name: "Macro", path: "./Macro")
    ],
    targets: [
        .target(
            name: "ReactiveDataComponents",
            dependencies:  ["ReactiveDataDisplayManager", "Macro"],
            path: "Sources"
        )
    ]
)
