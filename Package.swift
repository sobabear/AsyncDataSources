import PackageDescription

let package = Package(
  name: "AsyncDataSources",
  platforms: [
    .iOS(.v13),
  ],
  products: [
    .library(
      name: "AsyncDataSources",
      targets: ["AsyncDataSources"]),
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "AsyncDataSources"),
    .testTarget(
      name: "AsyncDataSourcesTests",
      dependencies: ["AsyncDataSources"]
    ),
  ]
)
