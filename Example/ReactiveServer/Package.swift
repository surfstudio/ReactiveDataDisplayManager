// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ReactiveServer",
    platforms: [.macOS(.v12)],
    products: [
        .executable(
            name: "ReactiveServer",
            targets: ["ReactiveServer"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", .upToNextMajor(from: "4.0.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "ReactiveServer",
            dependencies: [
                .product(name: "Vapor", package: "vapor")
            ],
            path: "Sources")
    ]
)
