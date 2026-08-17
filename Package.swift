// swift-tools-version: 6.3.3

import PackageDescription

let package = Package(
    name: "swift-byte-formatter-primitives",
    platforms: [
        .macOS("27"),
        .iOS("27"),
        .tvOS("27"),
        .watchOS("27"),
        .visionOS("27"),
    ],
    products: [
        // MARK: - Sub-namespace (lean, radix-free entry point)
        .library(
            name: "Byte Size Formatter Primitives",
            targets: ["Byte Size Formatter Primitives"]
        ),

        // MARK: - Primary entry point (Byte.Formatter — hex; re-exports byte-size)
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
        // `Byte.Size.Scale` + `Byte.Size.Formatter` — the generic byte-size
        // rendering algorithm and its injected prefix-ladder witness. Carries
        // NO SI/IEC knowledge; the concrete decimal/binary ladders are injected
        // from L2. Depends only on `Byte` (for the namespace) and the
        // `Formatter.Protocol` capability — never on a radix engine, so a
        // size-only consumer (e.g. swift-iec-80000-13) stays radix-free.
        .target(
            name: "Byte Size Formatter Primitives",
            dependencies: [
                .product(name: "Byte Primitive", package: "swift-byte-primitives"),
                .product(name: "Formatter Primitives", package: "swift-formatter-primitives"),
            ]
        ),

        // MARK: - Primary: byte hex formatting (Byte.Formatter) + package entry point
        //
        // `Byte.Formatter` — renders a single `Byte` as fixed-width text in a
        // given `Radix` (default hexadecimal, e.g. "ff"), using the radix's
        // digit alphabet. The repo-name-matching module: hosts the package's
        // DocC catalog and `@_exported`-re-exports `Byte Size Formatter
        // Primitives`, so `import Byte_Formatter_Primitives` surfaces the whole
        // package.
        .target(
            name: "Byte Formatter Primitives",
            dependencies: [
                "Byte Size Formatter Primitives",
                .product(name: "Byte Primitives", package: "swift-byte-primitives"),
                .product(name: "Radix Primitive", package: "swift-radix-primitives"),
                .product(name: "Formatter Primitives", package: "swift-formatter-primitives"),
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
