# SwiftLintBetterXcodePlugin
A better SwiftLint plugin for Xcode 14+
<p>
  <img src="https://img.shields.io/badge/Swift-5.6-f05318.svg" />
  <img src="https://img.shields.io/badge/iOS->= 13.0-blue.svg" />
  <img src="https://img.shields.io/badge/macOS->= 10.15-blue.svg" />
  <img src="https://img.shields.io/badge/watchOS->= 6.0-blue.svg" />
  <img src="https://img.shields.io/badge/tvOS->= 13.0-blue.svg" />

  <a href="https://twitter.com/drewsterbenson">
   @DrewsterBenson
  </a>
</p>

# SwiftLintBetterXcodePlugin

A Xcode build plugin that will run [SwiftLint](https://github.com/realm/SwiftLint/) at build time and show errors & warnings in Xcode.  This plugin correctly lints ALL the Swift source files associated with a target, and ONLY those Swift source files that are associated with the specific target being built.

## Xcode 14+ Integration

1. Add this package to your SPM dependencies in Xcode (`Project > Package Dependencies`), like this:
2. <img width="862" alt="Xcode add package dependency" src="https://github.com/drewster99/SwiftLintBetterXcodePlugin/assets/6386506/0905f861-f4da-4536-b34e-99295907e967">

3. Open your target's `Build Phases` screen
4. Expand `Run Build Tool Plug-ins` and hit `+` in that section to add a new build tool plug-in, and choose `SwiftLintBetterXcodePlugin`.

<img width="285" alt="Screen Shot 2022-09-02 at 09 33 23" src="https://user-images.githubusercontent.com/9460130/188084164-49903dc4-39a4-42fc-aa6f-6c6a813a7239.png">



## Add to Package

Instead of integrating with your Xcode project, you can use `SwiftLintBetterXcodePlugin` within your own Swift Packages.

First add a dependency from this package:

```swift
dependencies: [
    // ...
    .package(url: "https://github.com/drewster99/SwiftLintBetterXcodePlugin", from: "0.0.1"),
]
```

Then add it to your targets as a plugin:

```swift
targets: [
    .target(
        name: "YOUR_TARGET",
        dependencies: [],
        plugins: [
            .plugin(name: "SwiftLintBETTERXcodePlugin", package: "SwiftLintBETTERXcodePlugin")
        ]
    ),
]
```

### Example

```bash
xcodebuild  \
    -scheme "$SCHEME" \
    -destination "$PLATFORM" \
    -skipPackagePluginValidation \ # this is mandatory
    clean build
```

-----

<a href="https://www.buymeacoffee.com/drewbenson" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>
