// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SPMSupportExample",
    defaultLocalization: "ru",
    platforms: [.iOS(.v11)],
    products: [
        .library(
            name: "SPMSupportExample",
            targets: ["SPMSupportExample"]),
    ],
    dependencies: [
        // TODO: Заменить на основную после мержа
        .package(name: "ReactiveDataDisplayManager",
                 url: "https://github.com/surfstudio/ReactiveDataDisplayManager",
                 .branch("feature/spm-support")
        )
    ],
    targets: [
        .target(
            name: "SPMSupportExample",
            dependencies: ["ReactiveDataDisplayManager"]
        )
    ]
)
