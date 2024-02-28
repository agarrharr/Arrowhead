// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Arrowhead",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "BookmarkClient",
            targets: ["BookmarkClient"]),
        .library(
            name: "FileClient",
            targets: ["FileClient"]),
    ],
    dependencies: [
        .package(url: "https://www.github.com/pointfreeco/swift-dependencies", from: "1.2.1")
    ],
    targets: [
        .target(
            name: "BookmarkClient",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "DependenciesMacros", package: "swift-dependencies")
            ]
        ),
        .target(
            name: "FileClient",
            dependencies: [
                "BookmarkClient",
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "DependenciesMacros", package: "swift-dependencies")
            ]
        )
    ]
)
