// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Maze",
    platforms: [.macOS(.v14)],
    products: [
        .executable(name: "MazeApp", targets: ["MazeApp"])
    ],
    targets: [
        .target(name: "MazeCore"),
        .executableTarget(name: "MazeApp", dependencies: ["MazeCore"]),
        .testTarget(name: "MazeCoreTests", dependencies: ["MazeCore"])
    ]
)
