// swift-tools-version:5.3

import PackageDescription

struct ProjectSettings {
    static let marketingVersion: String = "3.1.1"
}

let package = Package(
    name: "SRGDiagnostics",
    platforms: [
        .iOS(.v12),
        .tvOS(.v12),
        .watchOS(.v5)
    ],
    products: [
        .library(
            name: "SRGDiagnostics",
            targets: ["SRGDiagnostics"]
        )
    ],
    targets: [
        .target(
            name: "SRGDiagnostics",
            cSettings: [
                .define("MARKETING_VERSION", to: "\"\(ProjectSettings.marketingVersion)\""),
                .define("NS_BLOCK_ASSERTIONS", to: "1", .when(configuration: .release))
            ]
        ),
        .testTarget(
            name: "SRGDiagnosticsTests",
            dependencies: ["SRGDiagnostics"],
            cSettings: [
                .headerSearchPath("Private")
            ]
        )
    ]
)
