// swift-tools-version: 5.8

// WARNING:
// This file is automatically generated.
// Do not edit it by hand because the contents will be replaced.

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "Blue Proxim",
    platforms: [
        .iOS("16.0")
    ],
    products: [
        .iOSApplication(
            name: "Blue Proxim",
            targets: ["AppModule"],
            bundleIdentifier: "com.alenjo.Blue-Proxim",
            teamIdentifier: "843A8K2LPK",
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .placeholder(icon: .pencil),
            accentColor: .presetColor(.brown),
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft,
                .portraitUpsideDown(.when(deviceFamilies: [.pad]))
            ],
            capabilities: [
                .bluetoothAlways(purposeString: "Allows finding nearby Bluetooth devices in your network and display basic information like signal strength, proximity, and their name. ")
            ]
        )
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            path: "."
        )
    ]
)