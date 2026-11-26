// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "YYText",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(name: "YYText", targets: ["YYText"])
    ],
    targets: [
        .target(
            name: "YYText",
            path: "YYText",
            publicHeadersPath: "include",
            cSettings: [
                .headerSearchPath("."),
                .headerSearchPath("Component"),
                .headerSearchPath("String"),
                .headerSearchPath("Utility")
            ],
            linkerSettings: [
                .linkedFramework("UIKit"),
                .linkedFramework("CoreFoundation"),
                .linkedFramework("CoreText"),
                .linkedFramework("QuartzCore"),
                .linkedFramework("Accelerate")
            ]
        )
    ]
)
