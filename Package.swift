// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import Foundation

let useUnsafeFlag = ProcessInfo.processInfo.environment["USE_UNSAFE_FLAG"]?.isEmpty == false
let settings: [SwiftSetting] = [
  .enableExperimentalFeature("StrictConcurrency")
]

let package = Package(
    name: "Viary",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "App",
            targets: ["App"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            .upToNextMajor(from: "10.12.0")
        ),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", .upToNextMajor(from: "1.1.5")),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", .upToNextMajor(from: "1.6.0")),
        .package(url: "https://github.com/pointfreeco/swift-identified-collections", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/pointfreeco/swiftui-navigation", .upToNextMajor(from: "1.2.0")),
        .package(url: "https://github.com/pointfreeco/swift-tagged", .upToNextMajor(from: "0.10.0")),
        .package(url: "https://github.com/pointfreeco/xctest-dynamic-overlay", .upToNextMajor(from: "1.0.2")),
        .package(url: "https://github.com/kateinoigakukun/StubKit.git",  .upToNextMajor(from: "0.1.0")),
        .package(url: "https://github.com/fummicc1/FloatingActionButton", .upToNextMinor(from: "0.0.2")),
        .package(url: "https://github.com/fummicc1/MoyaAPIClient", .upToNextMajor(from: "1.1.0")),
        .package(url: "https://github.com/Moya/Moya.git", .upToNextMajor(from: "15.0.0")),
        .package(url: "https://github.com/realm/realm-swift", .upToNextMajor(from: "10.33.0")),
        .package(url: "https://github.com/SFSafeSymbols/SFSafeSymbols", .upToNextMajor(from: "4.1.1")),
        .package(url: "https://github.com/sideeffect-io/AsyncExtensions", .upToNextMajor(from: "0.5.2")),
        .package(url: "https://github.com/apple/swift-async-algorithms", .upToNextMajor(from: "0.1.0")),
        .package(url: "https://github.com/fummicc1/RealmSwiftMacro", .upToNextMajor(from: "0.0.4")),
    ],
    targets: Package.appTargets + Package.utils + Package.speechToText + Package.sharedUI + Package.resources + Package.repositories + Package.localDataStore + Package.ja2En + Package.features + Package.entities + Package.emotionDetection
)

extension Package {
    static var appTargets: [Target] {
        [
            .target(
                name: "App",
                dependencies: [
                    .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                    .product(name: "Dependencies", package: "swift-dependencies"),
                    .product(name: "SwiftUINavigation", package: "swiftui-navigation"),
                    .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"),

                    "CreateViaryFeature",
                    "EditViaryFeature",
                    "ViaryListFeature",
                ],
				swiftSettings: settings
            ),
            .testTarget(
                name: "AppTests",
                dependencies: ["App"]
            ),
        ]
    }

    static var utils: [Target] {
        [
            .target(
                name: "Utils",
                dependencies: [],
                swiftSettings: useUnsafeFlag ?  [
                    .unsafeFlags(["-Xfrontend", "-strict-concurrency=complete"]),
                ] : settings
            ),
            .testTarget(name: "UtilsTests", dependencies: ["Utils"]),
        ]
    }

    static var speechToText: [Target] {
        [
            .target(
                name: "SpeechToText",
                dependencies: [
                    .product(name: "Dependencies", package: "swift-dependencies"),
                    .product(name: "AsyncExtensions", package: "AsyncExtensions"),
                ],
                swiftSettings: useUnsafeFlag ?  [
                    .unsafeFlags(["-Xfrontend", "-strict-concurrency=complete"]),
                ] : settings
            ),
            .testTarget(name: "SpeechToTextTests", dependencies: ["SpeechToText"]),
        ]
    }

    static var sharedUI: [Target] {
        [
            .target(
                name: "SharedUI",
                dependencies: [
                    .product(name: "SFSafeSymbols", package: "SFSafeSymbols"),
                ],
                swiftSettings: useUnsafeFlag ?  [
                    .unsafeFlags(["-Xfrontend", "-strict-concurrency=complete"]),
                ] : settings
            ),
            .testTarget(name: "SharedUITests", dependencies: ["SharedUI"]),
        ]
    }

    static var resources: [Target] {
        [
            .target(
                name: "Resources",
                dependencies: [],
                resources: [
                    .process("Resources/emotion-english-distilroberta-base.mlpackage"),
                    .process("Resources/vocab.json"),
                ],
                swiftSettings: useUnsafeFlag ?  [
                    .unsafeFlags(["-Xfrontend", "-strict-concurrency=complete"]),
                ] : settings
            ),
            .testTarget(name: "ResourcesTests", dependencies: ["Resources"])
        ]
    }

    static var repositories: [Target] {
        [
            .target(
                name: "Repositories",
                dependencies: [
                    .product(name: "MoyaAPIClient", package: "MoyaAPIClient"),
                    .product(name: "Tagged", package: "swift-tagged"),
                    .product(name: "IdentifiedCollections", package: "swift-identified-collections"),
                    .product(name: "Moya", package: "Moya"),
                    .product(name: "Dependencies", package: "swift-dependencies"),
                    .product(name: "XCTestDynamicOverlay", package: "xctest-dynamic-overlay"),
                    "LocalDataStore",
                    "Entities",
                ],
                swiftSettings: useUnsafeFlag ?  [
                    .unsafeFlags(["-Xfrontend", "-strict-concurrency=complete"]),
                ] : settings
            ),
            .testTarget(
                name: "RepositoriesTests",
                dependencies: [
                    "Repositories",
                ]
            )
        ]
    }

    static var localDataStore: [Target] {
        [
            .target(
                name: "LocalDataStore",
                dependencies: [
                    .product(name: "RealmSwift", package: "realm-swift"),
                    .product(name: "RealmSwiftMacro", package: "RealmSwiftMacro"),
                    .product(name: "Dependencies", package: "swift-dependencies"),

                ],
                swiftSettings: useUnsafeFlag ?  [
                    .unsafeFlags(["-Xfrontend", "-strict-concurrency=complete"]),
                ] : settings
            ),
            .testTarget(
                name: "LocalDataStoreTests",
                dependencies: [
                    "LocalDataStore"
                ]
            )
        ]
    }

    static var ja2En: [Target] {
        [
            .target(
                name: "Ja2En",
                dependencies: [
                    .product(name: "MoyaAPIClient", package: "MoyaAPIClient"),
                    .product(name: "Moya", package: "Moya"),
                    .product(name: "Dependencies", package: "swift-dependencies"),
                ],
                swiftSettings: useUnsafeFlag ?  [
                    .unsafeFlags(["-Xfrontend", "-strict-concurrency=complete"]),
                ] : settings
            ),
            .testTarget(
                name: "Ja2EnTests",
                dependencies: [
                    "Ja2En"
                ]
            )
        ]
    }

    static var features: [Target] {
        [
            .target(
                name: "CreateViaryFeature",
                dependencies: [

                    .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                    .product(name: "Dependencies", package: "swift-dependencies"),
                    .product(name: "SwiftUINavigation", package: "swiftui-navigation"),
                    .product(name: "SFSafeSymbols", package: "SFSafeSymbols"),

                    "SharedUI",
                    "Utils",
                    "Ja2En",
                    "Repositories",
                    "Entities",
                    "EmotionDetection",
                    "SpeechToText",
                ],
                path: "Sources/Features/CreateViaryFeature",
                swiftSettings: useUnsafeFlag ?  [
                    .unsafeFlags(["-Xfrontend", "-strict-concurrency=complete"]),
                ] : settings
            ),
            .testTarget(
                name: "CreateViaryFeatureTests",
                dependencies: [
                    "CreateViaryFeature",
                ],
                path: "Tests/FeaturesTests/CreateViaryFeatureTests"
            ),
            
            .target(
                name: "EditViaryFeature",
                dependencies: [
                    .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                    .product(name: "Dependencies", package: "swift-dependencies"),
                    .product(name: "SwiftUINavigation", package: "swiftui-navigation"),
                    .product(name: "Tagged", package: "swift-tagged"),
                    .product(name: "SFSafeSymbols", package: "SFSafeSymbols"),

                    "SharedUI",
                    "Entities",
                    "Utils",
                    "Ja2En",
                    "Repositories",
                    "EmotionDetection",
                ],
                path: "Sources/Features/EditViaryFeature",
                swiftSettings: useUnsafeFlag ?  [
                    .unsafeFlags(["-Xfrontend", "-strict-concurrency=complete"]),
                ] : settings
            ),
            .testTarget(
                name: "EditViaryFeatureTests",
                dependencies: [
                    "EditViaryFeature"
                ],
                path: "Tests/FeaturesTests/EditViaryFeatureTests"
            ),

            .target(
                name: "ViaryListFeature",
                dependencies: [
                    .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                    .product(name: "Dependencies", package: "swift-dependencies"),
                    .product(name: "SwiftUINavigation", package: "swiftui-navigation"),
                    .product(name: "SFSafeSymbols", package: "SFSafeSymbols"),
                    .product(name: "FloatingActionButton", package: "FloatingActionButton"),

                    "SharedUI",
                    "Entities",
                    "Utils",
                    "Ja2En",
                    "Repositories",
                    "EmotionDetection",
                ],
                path: "Sources/Features/ViaryListFeature",
                swiftSettings: useUnsafeFlag ?  [
                    .unsafeFlags(["-Xfrontend", "-strict-concurrency=complete"]),
                ] : settings
            ),
            .testTarget(
                name: "ViaryListFeatureTests",
                dependencies: [
                    "ViaryListFeature"
                ],
                path: "Tests/FeaturesTests/ViaryListFeatureTests"
            ),
        ]
    }

    static var entities: [Target] {
        [
            .target(
                name: "Entities",
                dependencies: [
                    .product(name: "Dependencies", package: "swift-dependencies"),
                    .product(name: "IdentifiedCollections", package: "swift-identified-collections"),
                    .product(name: "Tagged", package: "swift-tagged"),
                ],
                swiftSettings: useUnsafeFlag ?  [
                    .unsafeFlags(["-Xfrontend", "-strict-concurrency=complete"]),
                ] : settings
            ),
            .testTarget(
                name: "EntitiesTests",
                dependencies: [
                    "Entities"
                ]
            )
        ]
    }

    static var emotionDetection: [Target] {
        [
            .target(
                name: "EmotionDetection",
                dependencies: [
                    .product(name: "Dependencies", package: "swift-dependencies"),

                    "Entities",
                    "Resources",
                ],
                swiftSettings: useUnsafeFlag ?  [
                    .unsafeFlags(["-Xfrontend", "-strict-concurrency=complete"]),
                ] : settings
            ),
            .testTarget(
                name: "EmotionDetectionTests",
                dependencies: [
                    "EmotionDetection"
                ]
            )
        ]
    }
}
