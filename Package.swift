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
                "_DVGraph",
                "_SwiftUIZ_Nuke",
                "_SwiftUIZ_NukeUI",
                "MarkdownUI",
                "Emoji",
                "SwiftUIZ",
                "SwiftUIZ_Macros"
            ]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", from: "510.0.0"),
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
                "Swallow",
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftOperators", package: "swift-syntax"),
                .product(name: "SwiftParser", package: "swift-syntax"),
                .product(name: "SwiftParserDiagnostics", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ],
            path: "Sources/SwiftUIZ_Macros",
            swiftSettings: []
        ),
        .target(
            name: "cmark-gfm",
            path: "Sources/cmark-gfm"
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
            path: "Sources/_SwiftUIZ_Nuke"
        ),
        .target(
            name: "_SwiftUIZ_NukeUI",
            dependencies: [
                "_SwiftUIZ_Nuke"
            ],
            path: "Sources/_SwiftUIZ_NukeUI"
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
            name: "_DVGraph",
            dependencies: [
                "_SwiftUI_Internals",
                "CorePersistence",
                "Merge",
                "Swallow",
                "SwiftUIX",
                "SwiftUIZ_Macros",
            ],
            path: "Sources/_DVGraph",
            swiftSettings: []
        ),
        .target(
            name: "SwiftUIZ",
            dependencies: [
                "_DVGraph",
                "CorePersistence",
                "Merge",
                "Swallow",
                .product(name: "SwiftUIIntrospect", package: "SwiftUI-Introspect"),
                "SwiftUIX",
                "SwiftUIZ_Macros",
            ],
            path: "Sources/SwiftUIZ",
            swiftSettings: []
        ),
        .testTarget(
            name: "_DVGraphTests",
            dependencies: [
                "_DVGraph",
                "SwiftUIZ",
            ],
            path: "Tests/_DVGraph",
            swiftSettings: []
        )
    ]
)
