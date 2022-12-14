// swift-tools-version:5.3

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
        .package(url: "https://github.com/nysander/UnicodeURL.git", from: "0.1.0")
    ],

    targets: [
        .target(
            name: "TwitterText",
            dependencies: ["UnicodeURL"],
            path: "Sources/TwitterText",
            resources: [
                    .copy("config/v1.json"),
                    .copy("config/v2.json"),
                    .copy("config/v3.json"),
            ]
        ),
        .testTarget(name: "TwitterTextTests", dependencies: ["TwitterText"])
    ]
)
