// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "UnicodeURL",
    products: [
        .library(name: "UnicodeURL", targets: ["UnicodeURL"]),
        .library(name: "IDNSDK", targets: ["IDNSDK"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "IDNSDK", publicHeadersPath: "./"),
        .target(name: "UnicodeURL", dependencies: ["IDNSDK"]),
        .testTarget(name: "UnicodeURLTests", dependencies: ["UnicodeURL"]),
    ]
)