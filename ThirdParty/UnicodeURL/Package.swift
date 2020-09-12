// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UnicodeURL",
    products: [
        .library(name: "UnicodeURL", targets: ["UnicodeURL"]),
        .library(name: "IDNSDK", targets: ["IDNSDK"]),
    ],
    dependencies: [],
    targets: [
        .systemLibrary(name: "IDNSDK", path: "./Sources/IDNSDK"),
        .target(name: "UnicodeURL", dependencies: ["IDNSDK"]),
    ]
)
