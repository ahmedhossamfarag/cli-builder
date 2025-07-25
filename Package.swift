// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "cli-builder",
    dependencies: [
        .package(url: "https://github.com/wickwirew/Runtime.git", from: "2.2.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "cli-builder", 
            dependencies: ["Runtime"]
        ),
    ]
)
