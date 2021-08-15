//
//  UVs.swift
//
//  Created by Zack Brown on 26/11/2020.
//

import Euclid
import CoreGraphics

public struct UVs: Codable, Equatable {
    
    public let start: Vector
    public let end: Vector
    
    public var uvs: [Vector] { [start,
                         Vector(x: end.x, y: start.y, z: 0),
                         end,
                         Vector(x: start.x, y: end.y, z: 0)] }
    
    public init(start: Vector, end: Vector) {
        
        self.start = Vector.minimum(lhs: start, rhs: end)
        self.end = Vector.maximum(lhs: start, rhs: end)
    }
    
    subscript(index: Int) -> Vector {
    
        return uvs[index]
    }
}

extension UVs {
    
    func slice(cardinal: Cardinal) -> UVs {
        
        let center = start.lerp(end, 0.5)
        
        switch cardinal {
        
        case .north: return UVs(start: start, end: Vector(x: end.x, y: center.y, z: 0))
        case .east: return UVs(start: Vector(x: center.x, y: start.y, z: 0), end: end)
        case .south: return UVs(start: Vector(x: start.x, y: center.y, z: 0), end: end)
        case .west: return UVs(start: start, end: Vector(x: center.x, y: end.y, z: 0))
        }
    }
    
    func slice(ordinal: Ordinal) -> UVs {
        
        let center = start.lerp(end, 0.5)
        
        switch ordinal {
        
        case .northWest: return UVs(start: start, end: center)
        case .northEast: return UVs(start: Vector(x: center.x, y: start.y, z: 0), end: Vector(x: end.x, y: center.y, z: 0))
        case .southEast: return UVs(start: center, end: end)
        case .southWest: return UVs(start: Vector(x: start.x, y: center.y, z: 0), end: Vector(x: center.x, y: end.y, z: 0))
        }
    }
}
