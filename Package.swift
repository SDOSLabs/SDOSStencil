// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SDOSStencil",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(
            name: "SDOSStencilScript",
            targets: ["SDOSStencilScript"]),
    ],
    dependencies: [
        .package(url: "https://github.com/krzysztofzablocki/Sourcery.git", .upToNextMajor(from: "1.0.0")),
    ],
    targets: [
        .target(
            name: "SDOSStencilScript",
            dependencies: [
            ],
            path: "src/Classes"),
    ]
)
