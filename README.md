# Introduction
Meadow is a SceneKit and Metal based Swift library specifically designed to facilitate the rapid development of 3D games on both macOS and tv/iOS. Written collaboratively alongside [Harvest](https://github.com/zilmarinen/Harvest) and [Orchard](https://github.com/zilmarinen/Orchard), Meadow provides the fundamental building blocks of a 3D game engine wrapped up in a single `SCNNode`. 

## Installation

To install using Swift Package Manager, add the following to the `dependencies:` section in your `Package.swift` file:

```swift
.package(url: "https://github.com/zilmarinen/Meadow.git", .upToNextMinor(from: "0.1.0")),
```

## Dependencies
[Euclid](https://github.com/nicklockwood/Euclid) is a Swift library for creating and manipulating 3D geometry and is used extensively within this project for mesh generation and vector operations.