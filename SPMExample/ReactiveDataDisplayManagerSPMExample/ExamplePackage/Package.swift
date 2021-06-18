// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ExamplePackage",
    defaultLocalization: "ru",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "ExamplePackage",
            targets: ["ExamplePackage"])
    ],
    dependencies: [
        .package(name: "ReactiveDataDisplayManager",
                 url: "https://github.com/surfstudio/ReactiveDataDisplayManager",
                 .branch("feature/spm-support")
        )
    ],
    targets: [
        .target(
            name: "ExamplePackage",
            dependencies: ["ReactiveDataDisplayManager"])
    ]
)
