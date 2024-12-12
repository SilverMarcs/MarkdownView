// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "MarkdownView",
  platforms: [
    .macOS(.v14),
    .iOS(.v17),
    .watchOS(.v10),
    .tvOS(.v16),
    .visionOS(.v1),
    .macCatalyst(.v16),
  ],
  products: [
    .library(
      name: "MarkdownView",
      targets: ["MarkdownView"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-markdown", from: "0.5.0"),
    .package(url: "https://github.com/SilverMarcs/HighlightSwift", branch: "main"),
    .package(url: "https://github.com/colinc86/LaTeXSwiftUI", from: "1.3.2"),
    
  ],
  targets: [
    .target(
      name: "MarkdownView",
      dependencies: [
        .product(name: "Markdown", package: "swift-markdown"),
        .product(name: "HighlightSwift", package: "HighlightSwift"),
        .product(name: "LaTeXSwiftUI", package: "LaTeXSwiftUI"),
      ]
    ),
    .testTarget(
      name: "MarkdownViewTests",
      dependencies: [
        .target(name: "MarkdownView"),
      ]
    ),
  ]
)
