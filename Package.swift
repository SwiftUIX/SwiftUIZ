// swift-tools-version:5.9

import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "SwiftUIZ",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .tvOS(.v16),
        .watchOS(.v9)
    ],
    products: [
        .library(
            name: "SwiftUIZ",
            targets: [
                "Engine",
                "EngineCore",
                "EngineCoreC",
                "SwiftUIZ"
            ]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax", from: "509.0.0"),
        .package(url: "https://github.com/siteline/SwiftUI-Introspect", from: "0.2.3"),
        .package(url: "https://github.com/SwiftUIX/SwiftUIX.git", branch: "master"),
        .package(url: "https://github.com/vmanot/CorePersistence.git", branch: "main"),
        .package(url: "https://github.com/vmanot/Expansions.git", branch: "main"),
        .package(url: "https://github.com/vmanot/Merge.git", branch: "master"),
        .package(url: "https://github.com/vmanot/Swallow.git", branch: "master"),
    ],
    targets: [
        .macro(
            name: "SwiftUIZ_Macros",
            dependencies: [
                "Expansions",
                "Swallow",
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftOperators", package: "swift-syntax"),
                .product(name: "SwiftParser", package: "swift-syntax"),
                .product(name: "SwiftParserDiagnostics", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ],
            path: "Sources/SwiftUIZ_Macros"
        ),
        .target(
            name: "EngineCoreC"
        ),
        .target(
            name: "EngineCore",
            dependencies: [
                "EngineCoreC",
            ]
        ),
        .target(
            name: "Engine",
            dependencies: [
                "EngineCore",
                "EngineCoreC",
            ]
        ),
        .target(
            name: "SwiftUIZ",
            dependencies: [
                "EngineCoreC",
                "EngineCore",
                "Engine",
                "CorePersistence",
                "Expansions",
                "Merge",
                "Swallow",
                .product(name: "SwiftUIIntrospect", package: "SwiftUI-Introspect"),
                "SwiftUIX",
                "SwiftUIZ_Macros",
            ],
            path: "Sources/SwiftUIZ"
        )
    ]
)
