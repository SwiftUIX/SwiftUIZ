// swift-tools-version:5.9

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
                "_DynamicViewGraph",
                "MarkdownUI",
                "Emoji",
                "SwiftUIZ"
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
            name: "cmark-gfm",
            path: "Dependencies/cmark-gfm"
        ),
        .target(
            name: "_SwiftUI_Internals",
            dependencies: [
                "Swallow",
                "SwiftUIX"
            ],
            path: "Sources/_SwiftUI_Internals"
        ),
        .target(
            name: "_SwiftUIZ_Nuke",
            dependencies: [],
            path: "Dependencies/_SwiftUIZ_Nuke"
        ),
        .target(
            name: "_SwiftUIZ_NukeUI",
            dependencies: [
                "_SwiftUIZ_Nuke"
            ],
            path: "Dependencies/_SwiftUIZ_NukeUI"
        ),
        .target(
            name: "MarkdownUI",
            dependencies: [
                "_SwiftUIZ_Nuke",
                "_SwiftUIZ_NukeUI",
                "cmark-gfm",
                "Swallow",
                "SwiftUIX",
                "SwiftUIZ",
            ],
            path: "Sources/MarkdownUI",
            swiftSettings: []
        ),
        .target(
            name: "Emoji",
            dependencies: [
                "Swallow"
            ],
            path: "Sources/Emoji",
            resources: [
                .copy("Resources/emoji-data.json"),
                .copy("Resources/gemoji.json")
            ],
            swiftSettings: [
                .unsafeFlags([
                    "-enable-library-evolution",
                ])
            ]
        ),
        .target(
            name: "_SwiftUIZ_A",
            dependencies: [
                "CorePersistence",
                "Merge",
                "Swallow",
                .product(name: "SwiftUIIntrospect", package: "SwiftUI-Introspect"),
                "SwiftUIX",
                "SwiftUIZ_Macros",
            ],
            path: "Sources/_SwiftUIZ_A",
            swiftSettings: []
        ),
        .target(
            name: "_DynamicViewGraph",
            dependencies: [
                "_SwiftUI_Internals",
                "_SwiftUIZ_A",
                "SwiftUIZ_Macros",
            ],
            path: "Sources/_DynamicViewGraph",
            swiftSettings: []
        ),
        .target(
            name: "_SwiftUIZ_B",
            dependencies: [
                "_DynamicViewGraph",
                "_SwiftUIZ_A",
            ],
            path: "Sources/_SwiftUIZ_B",
            swiftSettings: []
        ),
        .target(
            name: "SwiftUIZ",
            dependencies: [
                "_SwiftUIZ_A",
                "_SwiftUIZ_B",
            ],
            path: "Sources/SwiftUIZ",
            swiftSettings: []
        ),
        .testTarget(
            name: "_DynamicViewGraphTests",
            dependencies: [
                "_DynamicViewGraph",
            ],
            path: "Tests/_DynamicViewGraph",
            swiftSettings: []
        )
    ]
)
