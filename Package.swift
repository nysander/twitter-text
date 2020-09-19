// swift-tools-version:5.1

//  twitter-text
//
//  Copyright (c) Paweł Madej 2020 | Twitter: @PawelMadejCK
//  License: MIT (see LICENCE files for details)

import PackageDescription

let package = Package(
    name: "twitter-text",
    products: [
        .library(name: "TwitterText", targets: ["TwitterText"])
    ],

    dependencies: [
        .package(url: "https://github.com/nysander/UnicodeURL.git", from: "0.0.3")
    ],

    targets: [
        .target(name: "TwitterText", dependencies: ["UnicodeURL"]),
        .testTarget(name: "TwitterTextTests", dependencies: ["TwitterText"])
    ]
)
