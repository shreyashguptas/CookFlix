// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "CookFlix",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "CookFlix",
            targets: ["CookFlix"])
    ],
    dependencies: [
        .package(url: "https://github.com/supabase-community/supabase-swift.git", from: "2.0.0")
    ],
    targets: [
        .target(
            name: "CookFlix",
            dependencies: [
                .product(name: "Supabase", package: "supabase-swift"),
                .product(name: "PostgREST", package: "supabase-swift"),
                .product(name: "Realtime", package: "supabase-swift"),
                .product(name: "Storage", package: "supabase-swift"),
                .product(name: "Functions", package: "supabase-swift")
            ],
            path: "CookFlix"
        )
    ]
) 