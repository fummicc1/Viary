// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CreateViaryFeature",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "CreateViaryFeature",
            targets: ["CreateViaryFeature"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(name: "Entities", path: "../../Entities"),
        .package(name: "Resources", path: "../../Resources"),
        .package(name: "Repositories", path: "../../Repositories"),
        .package(name: "EmotionDetection", path: "../../EmotionDetection"),
        .package(name: "Utils", path: "../../Utils"),
        .package(name: "SharedUI", path: "../../SharedUI"),
        .package(name: "SpeechToText", path: "../../SpeechToText"),
        .package(name: "Ja2En", path: "../../Ja2En"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", .upToNextMajor(from: "0.1.1")),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", .upToNextMajor(from: "0.49.0")),
        .package(url: "https://github.com/pointfreeco/swift-identified-collections", .upToNextMajor(from: "0.5.0")),
        .package(url: "https://github.com/pointfreeco/swiftui-navigation", .upToNextMajor(from: "0.6.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "CreateViaryFeature",
            dependencies: [
                .product(name: "Entities", package: "Entities"),
                .product(name: "Resources", package: "Resources"),
                .product(name: "Repositories", package: "Repositories"),
                .product(name: "EmotionDetection", package: "EmotionDetection"),                
                .product(name: "Utils", package: "Utils"),
                .product(name: "SharedUI", package: "SharedUI"),
                .product(name: "SpeechToText", package: "SpeechToText"),
                .product(name: "Ja2En", package: "Ja2En"),
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "IdentifiedCollections", package: "swift-identified-collections"),
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "SwiftUINavigation", package: "swiftui-navigation"),
            ]
        ),
        .testTarget(
            name: "CreateViaryFeatureTests",
            dependencies: ["CreateViaryFeature"]),
    ]
)
