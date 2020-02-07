//
//  World.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Foundation
import SceneKit

struct World {
    
    enum Constants {
        
        public static let ceiling = 20
        public static let floor = -World.Constants.ceiling
        public static let yStep = CGFloat(0.25)
        
        public static let chunkSize = 5
        public static let tileSize = 1
    }
    
    enum Axis {
        
        static func aligned(chunk coordinate: Coordinate) -> Volume {
            
            let size = Size(width: World.Constants.chunkSize, depth: World.Constants.chunkSize, height: (World.Constants.ceiling - World.Constants.floor))
            
            return Volume(coordinate: chunked(coordinate: coordinate), size: size)
        }
        
        static func aligned(tile coordinate: Coordinate) -> Volume {
            
            let size = Size(width: World.Constants.tileSize, depth: World.Constants.tileSize, height: (World.Constants.ceiling - World.Constants.floor))
            
            return Volume(coordinate: floored(coordinate: coordinate), size: size)
        }
        
        static func chunked(coordinate: Coordinate) -> Coordinate {
            
            let x = Int(floor(Double(coordinate.x) / Double(World.Constants.chunkSize))) * World.Constants.chunkSize
            let z = Int(floor(Double(coordinate.z) / Double(World.Constants.chunkSize))) * World.Constants.chunkSize
            
            return Coordinate(x: x, y: World.Constants.floor, z: z)
        }
        
        static func floored(coordinate: Coordinate) -> Coordinate {
            
            return Coordinate(x: coordinate.x, y: World.Constants.floor, z: coordinate.z)
        }
        
        static func y(y: Int) -> CGFloat {
            
            return CGFloat(y) * World.Constants.yStep
        }
        
        static func convert(coordinate: Coordinate) -> SCNVector3 {
            
            return SCNVector3(x: CGFloat(coordinate.x), y: World.Axis.y(y: coordinate.y), z: CGFloat(coordinate.z))
        }
    }
}

