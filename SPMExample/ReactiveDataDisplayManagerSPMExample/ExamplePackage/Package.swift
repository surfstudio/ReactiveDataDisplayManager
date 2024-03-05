// swift-tools-version:5.9
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
        .package(name: "ReactiveDataDisplayManager", path: "../../../"),
        .package(name: "ReactiveDataComponents", path: "../../../Components/")
    ],
    targets: [
        .target(
            name: "ExamplePackage",
            dependencies: ["ReactiveDataDisplayManager", "ReactiveDataComponents"])
    ]
)
