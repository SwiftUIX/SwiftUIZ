// swift-tools-version:5.10

import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "SwiftUIZ",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "SwiftUIZ",
            targets: [
                "_SwiftUI_Internals",
                "_SwiftUIZ_Nuke",
                "_SwiftUIZ_NukeUI",
                "_SwiftUIZ_A",
                "_SwiftUIZ_B",
                "Engine",
                "SwiftUIZ",
            ]
        ),
        .library(
            name: "MarkdownUI",
            targets: [
                "MarkdownUI",
            ]
        ),
        .library(
            name: "Emoji",
            targets: [
                "Emoji",
            ]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/siteline/SwiftUI-Introspect", from: "0.2.3"),
        .package(url: "https://github.com/SwiftUIX/SwiftUIX.git", branch: "master"),
        .package(url: "https://github.com/vmanot/CorePersistence.git", branch: "main"),
        .package(url: "https://github.com/vmanot/Merge.git", branch: "master"),
        .package(url: "https://github.com/vmanot/Swallow.git", branch: "master"),
    ],
    targets: [
        .macro(
            name: "SwiftUIZ_Macros",
            dependencies: [
                .product(name: "MacroBuilder", package: "Swallow"),
            ],
            path: "Macros",
            swiftSettings: []
        ),
        .target(
            name: "_SwiftUIZ_cmark-gfm",
            path: "Dependencies/cmark-gfm"
        ),
        .target(
            name: "_SwiftUI_Internals",
            dependencies: [
                "Swallow",
                "SwiftUIX"
            ],
            path: "Sources/_SwiftUI_Internals",
            swiftSettings: [
                .enableExperimentalFeature("AccessLevelOnImport")
            ]
        ),
        .target(
            name: "_SwiftUIZ_Nuke",
            dependencies: [],
            path: "Dependencies/_SwiftUIZ_Nuke",
            swiftSettings: [
                .enableExperimentalFeature("AccessLevelOnImport")
            ]
        ),
        .target(
            name: "_SwiftUIZ_NukeUI",
            dependencies: [
                "_SwiftUIZ_Nuke"
            ],
            path: "Dependencies/_SwiftUIZ_NukeUI",
            swiftSettings: [
                .enableExperimentalFeature("AccessLevelOnImport")
            ]
        ),
        .target(
            name: "Engine",
            dependencies: [
                "EngineCore",
            ],
            path: "Dependencies/Engine/Engine"
        ),
        .target(
            name: "EngineCore",
            dependencies: [
                "EngineCoreC",
            ],
            path: "Dependencies/Engine/EngineCore"
        ),
        .target(
            name: "EngineCoreC",
            path: "Dependencies/Engine/EngineCoreC"
        ),
        .target(
            name: "MarkdownUI",
            dependencies: [
                "_SwiftUIZ_Nuke",
                "_SwiftUIZ_NukeUI",
                "_SwiftUIZ_cmark-gfm",
                "Swallow",
                .product(name: "SwallowMacrosClient", package: "Swallow"),
                "SwiftUIX",
                "SwiftUIZ",
            ],
            path: "Miscellaneous/MarkdownUI",
            swiftSettings: [
                .enableExperimentalFeature("AccessLevelOnImport")
            ]
        ),
        .target(
            name: "Emoji",
            dependencies: [
                "Swallow"
            ],
            path: "Miscellaneous/Emoji",
            resources: [
                .copy("Resources/emoji-data.json"),
                .copy("Resources/gemoji.json")
            ],
            swiftSettings: [
                .enableExperimentalFeature("AccessLevelOnImport")
            ]
        ),
        .target(
            name: "_SwiftUIZ_A",
            dependencies: [
                "_SwiftUI_Internals",
                "CorePersistence",
                "Merge",
                "Swallow",
                .product(name: "SwallowMacrosClient", package: "Swallow"),
                .product(name: "SwiftUIIntrospect", package: "SwiftUI-Introspect"),
                "SwiftUIX",
                "SwiftUIZ_Macros",
            ],
            path: "Sources/_SwiftUIZ_A",
            swiftSettings: [
                .enableExperimentalFeature("AccessLevelOnImport")
            ]
        ),
        .target(
            name: "_SwiftUIZ_B",
            dependencies: [
                "_SwiftUI_Internals",
                "_SwiftUIZ_A",
                "SwiftUIZ_Macros",
            ],
            path: "Sources/_SwiftUIZ_B",
            swiftSettings: [
                .enableExperimentalFeature("AccessLevelOnImport")
            ]
        ),
        .target(
            name: "SwiftUIZ",
            dependencies: [
                "_SwiftUIZ_A",
                "_SwiftUIZ_B",
            ],
            path: "Sources/SwiftUIZ",
            swiftSettings: [
                .enableExperimentalFeature("AccessLevelOnImport")
            ]
        ),
    ]
)
