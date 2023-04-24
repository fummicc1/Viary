// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "App",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "App",
            targets: ["App"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(name: "Entities", path: "../Entities"),
        .package(name: "CreateViaryFeature", path: "../Features/CreateViaryFeature"),
        .package(name: "EditViaryFeature", path: "../Features/EditViaryFeature"),
        .package(name: "ViaryListFeature", path: "../Features/ViaryListFeature"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", .upToNextMajor(from: "0.1.1")),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", .upToNextMajor(from: "0.49.0")),
        .package(url: "https://github.com/pointfreeco/swift-identified-collections", .upToNextMajor(from: "0.5.0")),
        .package(url: "https://github.com/pointfreeco/swiftui-navigation", .upToNextMajor(from: "0.6.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "App",
            dependencies: [
                .product(name: "Entities", package: "Entities"),
                .product(name: "CreateViaryFeature", package: "CreateViaryFeature"),
                .product(name: "EditViaryFeature", package: "EditViaryFeature"),
                .product(name: "ViaryListFeature", package: "ViaryListFeature"),
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .testTarget(
            name: "AppTests",
            dependencies: ["App"]),
    ]
)
