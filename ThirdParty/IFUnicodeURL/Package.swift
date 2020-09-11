// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IFUnicodeURL",
    products: [
        .library(name: "IFUnicodeURL", targets: ["IFUnicodeURL"]),
        .library(name: "IFUnicodeURLSwift", targets: ["IFUnicodeURLSwift"]),
    ],
    dependencies: [],
    targets: [
        .systemLibrary(name: "IFUnicodeURL", path: "./Sources/"),
        .target(name: "IFUnicodeURLSwift"),
    ]
)
