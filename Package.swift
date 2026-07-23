// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NSFeatureFreshMock",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "NSFeatureFreshMock",
            targets: ["NSFeatureFreshMock"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/simplex-tech-apps/ns-core-design-system.git",
            from: "2.0.5"
        )
    ],
    targets: [
        .target(
            name: "NSFeatureFreshMock",
            dependencies: [
                .product(name: "NammaAppUI", package: "ns-core-design-system")
            ]
        )
    ]
)
