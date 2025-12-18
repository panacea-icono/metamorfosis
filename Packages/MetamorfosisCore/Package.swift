// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MetamorfosisCore",
    platforms: [.iOS(.v17), .macOS(.v13)],
    products: [
        .library(name: "MetamorfosisCore", targets: ["MetamorfosisCore"])
    ],
    targets: [
        .target(name: "MetamorfosisCore"),
        .testTarget(name: "MetamorfosisCoreTests", dependencies: ["MetamorfosisCore"])
    ]
)
