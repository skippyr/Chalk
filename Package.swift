// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Chalk",
    platforms: [
        .macOS(.v15)
    ],
    dependencies: [
        .package(url: "https://github.com/onevcat/Rainbow", .upToNextMajor(from: "4.0.0"))
    ],
    targets: [
        .executableTarget(name: "chalk", dependencies: ["Rainbow"])
    ]
)
