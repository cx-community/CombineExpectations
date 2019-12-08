// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CombineExpectations",
    platforms: [
        .iOS(.v8),
        .macOS(.v10_10),
        .tvOS(.v9),
        .watchOS(.v2),
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "CombineExpectations",
            targets: ["CombineExpectations"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/cx-org/CombineX", .upToNextMinor(from: "0.1.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "CombineExpectations",
            dependencies: ["CXShim"]),
        .testTarget(
            name: "CombineExpectationsTests",
            dependencies: ["CombineExpectations", "CXShim"]),
    ]
)

enum CombineImplementation {
    
    case combine, combineX, openCombine
    
    static var `default`: CombineImplementation {
        #if canImport(Combine)
        return .combine
        #else
        return .openCombine
        #endif
    }
    
    init?(_ description: String) {
        let desc = description.lowercased().filter { $0.isLetter }
        switch desc {
        case "combine":     self = .combine
        case "combinex":    self = .combineX
        case "opencombine": self = .openCombine
        default:            return nil
        }
    }
}

import Foundation

let env = ProcessInfo.processInfo.environment
let implkey = "CX_COMBINE_IMPLEMENTATION"
let combineImpl = env[implkey].flatMap(CombineImplementation.init) ?? .default

if combineImpl == .combine {
    package.platforms = [
        .iOS("13.0"),
        .macOS("10.15"),
        .tvOS("13.0"),
        .watchOS("6.0"),
    ]
}
