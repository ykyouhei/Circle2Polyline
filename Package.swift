// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Circle2Polyline",
    products: [
        .executable(name: "circle2polyline", targets: ["Circle2Polyline"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-package-manager.git", from: "0.3.0"),
        .package(url: "https://github.com/raphaelmor/Polyline.git", .branch("master"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Circle2Polyline",
            dependencies: [
                "Utility",
                "Polyline"
            ]
        ),
        .testTarget(
            name: "Circle2PolylineTests",
            dependencies: ["Circle2Polyline"]),
    ]
)
