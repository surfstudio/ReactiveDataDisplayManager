// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "ReactiveDataDisplayManager",
    platforms: [
        .iOS(.v11),
    ],
    products: [
        .library(
            name: "ReactiveDataDisplayManager",
            targets: [
                "ReactiveDataDisplayManager"
            ]),
    ],
    targets: [
        .target(
            name: "ReactiveDataDisplayManager",
            path: "Source"
        ),
        .testTarget(
            name: "ReactiveDataDisplayManagerTests",
            dependencies: [
                "ReactiveDataDisplayManager"
            ],
            path: "ReactiveDataDisplayManagerTests",
            exclude: [
                "Info.plist"
            ]
        )
    ]
)

