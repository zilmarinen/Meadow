//
//  TileVolume.swift
//
//  Created by Zack Brown on 11/05/2021.
//

import Foundation

public struct TileVolume: Codable {
    
    public struct Apex: Codable, Equatable {
        
        public let corners: [Double]
        
        public init(corners: [Double]) {
            
            self.corners = corners
        }
        
        public init(corners: Double) {
            
            self.corners = Array(repeating: corners, count: 4)
        }
    }
    
    public let apex: Apex
    public let edges: [Cardinal : [Ordinal : Double]]
    
    public init(apex: Apex, edges: [Cardinal : [Ordinal : Double]]) {
        
        self.apex = apex
        self.edges = edges
    }
}

extension TileVolume {
    
    static func face(position: Vector, size: Double, elevation: Int) -> [Vector] {
        
        let y = Double(elevation) * World.Constants.slope
        
        return [
            
            position + Vector(x: -size, y: y, z: -size),
            position + Vector(x: size, y: y, z: -size),
            position + Vector(x: size, y: y, z: size),
            position + Vector(x: -size, y: y, z: size)
        ]
    }
    
    static func face(position: Vector, size: Coordinate, elevation: Int) -> [Vector] {
        
        let x = Double(size.x) / 2.0
        let z = Double(size.z) / 2.0
        let y = Double(elevation) * World.Constants.slope
        
        return [
            
            position + Vector(x: -x, y: y, z: -z),
            position + Vector(x: x, y: y, z: -z),
            position + Vector(x: x, y: y, z: z),
            position + Vector(x: -x, y: y, z: z)
        ]
    }
}
