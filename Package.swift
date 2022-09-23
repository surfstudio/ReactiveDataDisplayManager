// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "ReactiveDataDisplayManager",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "ReactiveDataDisplayManager",
            targets: [
                "ReactiveDataDisplayManager"
            ]),
          .library(
              name: "ReactiveDataComponents",
              targets: [
                  "ReactiveDataComponents"
              ])
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
        ),
        .target(
            name: "ReactiveDataComponents",
            dependencies: [
                "ReactiveDataDisplayManager"
            ],
            path: "Components/Source"
        ),
        .testTarget(
            name: "ReactiveDataComponentsTests",
            dependencies: [
                "ReactiveDataDisplayManager",
                "ReactiveDataComponents"
            ],
            path: "ReactiveDataComponentsTests",
            exclude: [
                "Info.plist"
            ]
        )
    ]
)
