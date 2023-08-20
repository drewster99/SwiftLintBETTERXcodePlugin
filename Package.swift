// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftLintBetterXcodePlugin",
    platforms: [
        .iOS(.v13),
        .watchOS(.v6),
        .macOS(.v10_15),
        .tvOS(.v13),
    ],
    products: [
        // Products can be used to vend plugins, making them visible to other packages.
        .plugin(
            name: "SwiftLintBetterXcodePlugin",
            targets: ["SwiftLintBetterXcodePlugin"]),
    ],
    dependencies: [
        
    ],
    targets: [
        .binaryTarget(
            name: "SwiftLintBinary",
            url: "https://github.com/realm/SwiftLint/releases/download/0.52.4/SwiftLintBinary-macos.artifactbundle.zip",
            checksum: "8a8095e6235a07d00f34a9e500e7568b359f6f66a249f36d12cd846017a8c6f5"
        ),
        .plugin(
            name: "SwiftLintBetterXcodePlugin",
            capability: .buildTool(),
            dependencies: [.target(name: "SwiftLintBinary")]
        ),
    ]
)
