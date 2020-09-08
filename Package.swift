// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "twitter-text",
    products: [
        .library(name: "TwitterText", targets: ["TwitterText"]),
    ],

    dependencies: [
        .package(path: "./ThirdParty/UnicodeURL")
    ],

    targets: [
        .target(name: "TwitterText", dependencies: ["UnicodeURL"]),
        .testTarget(name: "TwitterTextTests", dependencies: ["TwitterText"]),
    ]
)
