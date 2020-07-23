//
//  World.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Pasture

public struct World {
    
    public enum Constants {
        
        public static let ceiling = 20
        public static let floor = -ceiling
        public static let yStep = Double(0.25)
        
        public static let chunkSize = 5
        public static let tileSize = 1
        
        public static let x = Plane(normal: .x, distance: 0.0)
        public static let y = Plane(normal: .y, distance: 0.0)
        public static let z = Plane(normal: .z, distance: 0.0)
    }
    
    public enum Axis {
        
        public static func xz(value: Double) -> Int {
            
            return Int(round(value))
        }
        
        public static func y(value: Int) -> Double {
            
            return Double(value) * World.Constants.yStep
        }
        
        public static func y(value: Double) -> Int {
            
            return Int(value / World.Constants.yStep)
        }
        
        public static func segment(vector: Vector) -> Int {
            
            let x = vector.compare(with: Constants.x) == .back
            let z = vector.compare(with: Constants.z) == .back
            
            return (x ? (z ? 1 : 0) : (z ? 2 : 3))
        }
        
        public static func radius(vector: Vector) -> Int {
            
            return Int(floor(vector.magnitude / Double(World.Constants.chunkSize))) * World.Constants.chunkSize
        }
    }
}
