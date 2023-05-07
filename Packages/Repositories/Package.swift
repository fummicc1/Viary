// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Repositories",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Repositories",
            targets: ["Repositories"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/fummicc1/MoyaAPIClient", .upToNextMajor(from: "1.0.0")),
        .package(name: "LocalDataStore", path: "../LocalDataStore"),
        .package(name: "Entities", path: "../Entities"),
        .package(url: "https://github.com/pointfreeco/swift-tagged", .upToNextMajor(from: "0.6.0")),
        .package(url: "https://github.com/pointfreeco/swift-identified-collections", .upToNextMajor(from: "0.6.0")),
        .package(url: "https://github.com/Moya/Moya.git", .upToNextMajor(from: "15.0.0")),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", .upToNextMajor(from: "0.1.1")),
        .package(url: "https://github.com/pointfreeco/xctest-dynamic-overlay", .upToNextMajor(from: "0.8.1")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Repositories",
            dependencies: [
                .product(name: "MoyaAPIClient", package: "MoyaAPIClient"),
                .product(name: "LocalDataStore", package: "LocalDataStore"),
                .product(name: "Entities", package: "Entities"),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "IdentifiedCollections", package: "swift-identified-collections"),
                .product(name: "Moya", package: "Moya"),
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "XCTestDynamicOverlay", package: "xctest-dynamic-overlay"),
            ]
        ),
        .testTarget(
            name: "RepositoriesTests",
            dependencies: ["Repositories"]),
    ]
)
