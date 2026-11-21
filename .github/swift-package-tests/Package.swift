// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "SwiftPackageIntegration",
    platforms: [.iOS(.v11)],
    products: [
        .library(name: "SwiftPackageIntegration", targets: ["ObjectiveCConsumer"])
    ],
    dependencies: [
        .package(path: "../..")
    ],
    targets: [
        .target(
            name: "ObjectiveCConsumer",
            dependencies: [
                .product(name: "RTRootNavigationController", package: "RTRootNavigationController")
            ]
        ),
        .testTarget(
            name: "SwiftPackageIntegrationTests",
            dependencies: [
                "ObjectiveCConsumer",
                .product(name: "RTRootNavigationController", package: "RTRootNavigationController")
            ]
        )
    ]
)
