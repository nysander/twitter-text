// swift-tools-version:5.1

//  UnicodeURL
//
//  Copyright (c) Paweł Madej 2020 | Twitter: @PawelMadejCK
//  License: Apache Licence 2.0 (see LICENCE files for details)

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
