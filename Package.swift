// swift-tools-version: 6.3.1

import PackageDescription

let package = Package(
    name: "swift-byte-formatter-primitives",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26),
    ],
    products: [
        // MARK: - Sub-namespaces
        .library(
            name: "Byte Size Format Primitives",
            targets: ["Byte Size Format Primitives"]
        ),
        .library(
            name: "Byte Format Primitives",
            targets: ["Byte Format Primitives"]
        ),

        // MARK: - Umbrella
        .library(
            name: "Byte Formatter Primitives",
            targets: ["Byte Formatter Primitives"]
        ),

        // MARK: - Test Support
        .library(
            name: "Byte Formatter Primitives Test Support",
            targets: ["Byte Formatter Primitives Test Support"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-primitives/swift-byte-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-radix-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-formatter-primitives.git", branch: "main"),
    ],
    targets: [
        // MARK: - Sub-namespace: byte-size formatting (the dependency-inversion seam)
        //
        // `Byte.Size.Scale` + `Byte.Size.Format` — the generic byte-size
        // rendering algorithm and its injected prefix-ladder witness. Carries
        // NO SI/IEC knowledge; the concrete decimal/binary ladders are injected
        // from L2. Depends only on `Byte` (for the namespace) and the
        // `Formatter.Protocol` capability — never on a radix engine.
        .target(
            name: "Byte Size Format Primitives",
            dependencies: [
                .product(name: "Byte Primitive", package: "swift-byte-primitives"),
                .product(name: "Formatter Primitives", package: "swift-formatter-primitives"),
            ]
        ),

        // MARK: - Sub-namespace: byte hex formatting
        //
        // `Byte.Format` — renders a single `Byte` as fixed-width text in a given
        // `Radix` (default hexadecimal, e.g. "ff"), using the radix's digit
        // alphabet. Depends on `Byte`, `Radix`, and the `Formatter.Protocol`
        // capability.
        .target(
            name: "Byte Format Primitives",
            dependencies: [
                .product(name: "Byte Primitives", package: "swift-byte-primitives"),
                .product(name: "Radix Primitive", package: "swift-radix-primitives"),
                .product(name: "Formatter Primitives", package: "swift-formatter-primitives"),
            ]
        ),

        // MARK: - Umbrella
        .target(
            name: "Byte Formatter Primitives",
            dependencies: [
                "Byte Size Format Primitives",
                "Byte Format Primitives",
            ]
        ),

        // MARK: - Test Support
        .target(
            name: "Byte Formatter Primitives Test Support",
            dependencies: [
                "Byte Formatter Primitives",
            ],
            path: "Tests/Support"
        ),

        // MARK: - Tests
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
        .enableExperimentalFeature("LifetimeDependence"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("LifetimeDependence"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
