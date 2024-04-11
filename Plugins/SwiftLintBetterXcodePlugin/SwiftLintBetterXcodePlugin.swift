import PackagePlugin
import Foundation

fileprivate func announce(_ title: String) {
    print("***\n*** SwiftLintBetterXcodePlugin\n***\n*** \(title)\n***")
}
@main
struct SwiftLintBetterXcodePlugin: BuildToolPlugin {
    /// Entry point for creating build commands for targets in Swift packages.
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        announce("BuildToolPlugin")
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
        print("*** TRYING TO LINT USING CONFIG PATH \(configPath)")
        if FileManager.default.fileExists(atPath: configPath) {
            arguments.append(contentsOf: [
                "--config",
                configPath
            ])
        }

        let cachePath = "\(context.pluginWorkDirectory.string)"
        print("*** TRYING TO USE WORK DIRECTORY \(cachePath)")
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
        announce("XcodeBuildToolPlugin")
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
        print("*** TRYING TO LINT USING CONFIG PATH \(configPath)")
        if FileManager.default.fileExists(atPath: configPath) {
            arguments.append(contentsOf: [
                "--config",
                configPath
            ])
        }

        let cachePath = "\(context.pluginWorkDirectory.string)"
        print("*** TRYING TO USE WORK DIRECTORY \(cachePath)")
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
