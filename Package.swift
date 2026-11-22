// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "RTRootNavigationController",
    platforms: [.iOS(.v11)],
    products: [
        .library(name: "RTRootNavigationController", targets: ["RTRootNavigationController"])
    ],
    targets: [
        .target(
            name: "RTRootNavigationController",
            path: "RTRootNavigationController/Classes",
            publicHeadersPath: ".",
            linkerSettings: [
                .linkedFramework("UIKit"),
                .linkedFramework("Foundation")
            ]
        )
    ]
)
