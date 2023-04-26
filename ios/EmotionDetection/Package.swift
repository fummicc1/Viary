// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EmotionDetection",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "EmotionDetection",
            targets: ["EmotionDetection"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(name: "Entities", path: "../Entities"),
        .package(name: "Resources", path: "../Resources"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", .upToNextMajor(from: "0.1.1")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "EmotionDetection",
            dependencies: [
                .product(name: "Entities", package: "Entities"),
                .product(name: "Resources", package: "Resources"),
                .product(name: "Dependencies", package: "swift-dependencies"),
            ]
        ),
        .testTarget(
            name: "EmotionDetectionTests",
            dependencies: ["EmotionDetection"]),
    ]
)
