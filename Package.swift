// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-byte-formatter",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [

        .library(
            name: "Byte Size Formatter",
            targets: ["Byte Size Formatter"]
        ),

        .library(
            name: "Byte Formatter",
            targets: ["Byte Formatter"]
        ),

        .library(
            name: "Byte Formatter Test Support",
            targets: ["Byte Formatter Test Support"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-atoms/swift-byte.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-radix.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-formatter.git",
            branch: "main"
        ),
    ],
    targets: [

        .target(
            name: "Byte Size Formatter",
            dependencies: [
                .product(name: "Byte", package: "swift-byte"),
                .product(name: "Formatter", package: "swift-formatter"),
            ]
        ),

        .target(
            name: "Byte Formatter",
            dependencies: [
                "Byte Size Formatter",
                .product(name: "Byte", package: "swift-byte"),
                .product(name: "Radix", package: "swift-radix"),
                .product(name: "Formatter", package: "swift-formatter"),
            ]
        ),

        .target(
            name: "Byte Formatter Test Support",
            dependencies: [
                "Byte Formatter"
            ],
            path: "Tests/Support"
        ),

        .testTarget(
            name: "Byte Formatter Tests",
            dependencies: [
                "Byte Formatter",
                "Byte Formatter Test Support",
            ],
            path: "Tests/Byte Formatter Tests"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
