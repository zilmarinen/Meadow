//
//  UVs.swift
//
//  Created by Zack Brown on 26/11/2020.
//

import CoreGraphics

public struct UVs: Codable, Equatable {
    
    public let start: Vector
    public let end: Vector
    
    var uvs: [Vector] { [Vector(x: end.x, y: end.y, z: 0),
                         Vector(x: start.x, y: end.y, z: 0),
                         Vector(x: start.x, y: start.y, z: 0),
                         Vector(x: end.x, y: start.y, z: 0)] }
    
    public init(start: Vector, end: Vector) {
        
        self.start = Vector(x: Math.quantize(value: start.x), y: Math.quantize(value: start.y), z: Math.quantize(value: start.z))
        self.end = Vector(x: Math.quantize(value: end.x), y: Math.quantize(value: end.y), z: Math.quantize(value: end.z))
    }
    
    subscript(index: Int) -> Vector {
    
        return uvs[index]
    }
}
