// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUtils",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "SwiftUtils", targets: [
            "SwiftUtils"
        ]),
    ],
    dependencies: [
        .package(url: "https://github.com/MarcioFPaludo/ExceptionCatcher", from: "2.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(name: "SwiftUtils", dependencies: [
            .product(name: "ExceptionCatcher", package: "ExceptionCatcher")
        ]),
        .testTarget(name: "SwiftUtilsTests", dependencies: [
            "SwiftUtils"
        ]),
    ]
)
