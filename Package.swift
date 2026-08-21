// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-byte-formatter-primitives",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [

        .library(
            name: "Byte Size Formatter Primitives",
            targets: ["Byte Size Formatter Primitives"]
        ),

        .library(
            name: "Byte Formatter Primitives",
            targets: ["Byte Formatter Primitives"]
        ),

        .library(
            name: "Byte Formatter Primitives Test Support",
            targets: ["Byte Formatter Primitives Test Support"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-primitives/swift-byte-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-radix-primitives.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-formatter-primitives.git",
            branch: "main"
        ),
    ],
    targets: [

        .target(
            name: "Byte Size Formatter Primitives",
            dependencies: [
                .product(name: "Byte Primitive", package: "swift-byte-primitives"),
                .product(name: "Formatter Primitives", package: "swift-formatter-primitives"),
            ]
        ),

        .target(
            name: "Byte Formatter Primitives",
            dependencies: [
                "Byte Size Formatter Primitives",
                .product(name: "Byte Primitives", package: "swift-byte-primitives"),
                .product(name: "Radix Primitive", package: "swift-radix-primitives"),
                .product(name: "Formatter Primitives", package: "swift-formatter-primitives"),
            ]
        ),

        .target(
            name: "Byte Formatter Primitives Test Support",
            dependencies: [
                "Byte Formatter Primitives"
            ],
            path: "Tests/Support"
        ),

        .testTarget(
            name: "Byte Formatter Primitives Tests",
            dependencies: [
                "Byte Formatter Primitives",
                "Byte Formatter Primitives Test Support",
            ],
            path: "Tests/Byte Formatter Primitives Tests"
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
