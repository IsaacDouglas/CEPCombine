// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CEPCombine",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(name: "CEPCombine", targets: ["CEPCombine"])
    ],
    targets: [
        .target(
            name: "CEPCombine",
            path: "CEPCombine/Classes"
        )
    ]
)
