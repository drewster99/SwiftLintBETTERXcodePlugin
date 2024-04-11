import PackagePlugin
import Foundation

@main
struct SwiftLintBetterXcodePlugin: BuildToolPlugin {
    /// Entry point for creating build commands for targets in Swift packages.
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        let swiftLintPath = try context.tool(named: "swiftlint").path
        
        /// paths of Swift source files in this target
        let paths = (target as? SourceModuleTarget)?.sourceFiles
            .filter({ sourceFile in
                sourceFile.path.lastComponent.hasSuffix(".swift")
            })
            .map({ sourceFile in
                sourceFile.path.string
            })
        ?? []

        /// command line arguments for swiftlint binary
        var arguments: [String] = [
            "lint",
        ]

        let configPath = "\(context.package.directory.string)/.swiftlint.yml"
        if FileManager.default.fileExists(atPath: configPath) {
            arguments.append(contentsOf: [
                "--config",
                configPath
            ])
        }

        let cachePath = "\(context.pluginWorkDirectory.string)"
        if !FileManager.default.fileExists(atPath: cachePath) {
            try FileManager.default.createDirectory(atPath: cachePath, withIntermediateDirectories: true)
        }
        arguments.append(contentsOf: [
            "--cache-path",
            cachePath
        ])

        arguments.append(contentsOf: paths)

        return [
            .buildCommand(
                displayName: "SwiftLintBetterXcodePlugin",
                executable: swiftLintPath,
                arguments: arguments,
                environment: [:]
            )
        ]
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension SwiftLintBetterXcodePlugin: XcodeBuildToolPlugin {
    // Entry point for creating build commands for targets in Xcode projects.
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        let swiftLintPath = try context.tool(named: "swiftlint").path

        /// paths of Swift source files in this target
        let paths = target.inputFiles
            .filter({ sourceFile in
                sourceFile.path.lastComponent.hasSuffix(".swift")
            })
            .map({ sourceFile in
                sourceFile.path.string
            })

        /// command line arguments for swiftlint binary
        var arguments: [String] = [
            "lint",
        ]

        let configPath = "\(context.xcodeProject.directory.string)/.swiftlint.yml"
        if FileManager.default.fileExists(atPath: configPath) {
            arguments.append(contentsOf: [
                "--config",
                configPath
            ])
        }

        let cachePath = "\(context.pluginWorkDirectory.string)"
        if !FileManager.default.fileExists(atPath: cachePath) {
            try FileManager.default.createDirectory(atPath: cachePath, withIntermediateDirectories: true)
        }
        arguments.append(contentsOf: [
            "--cache-path",
            cachePath
        ])

        arguments.append(contentsOf: paths)

        return [
            .buildCommand(
                displayName: "SwiftLintBetterXcodePlugin",
                executable: swiftLintPath,
                arguments: arguments,
                environment: [:]
            )
        ]
    }
}

#endif
