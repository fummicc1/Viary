// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SharedUI",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SharedUI",
            targets: ["SharedUI"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/SFSafeSymbols/SFSafeSymbols", .upToNextMajor(from: "4.1.1"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SharedUI",
            dependencies: [
                .product(name: "SFSafeSymbols", package: "SFSafeSymbols"),
            ]
        ),
        .testTarget(
            name: "SharedUITests",
            dependencies: ["SharedUI"]),
    ]
)
