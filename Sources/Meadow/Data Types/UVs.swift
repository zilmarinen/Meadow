//
//  UVs.swift
//
//  Created by Zack Brown on 26/11/2020.
//

import Euclid
import CoreGraphics

public struct UVs: Codable, Equatable {
    
    public static let corners: UVs = UVs(start: .zero, end: .one)
    
    public let start: Vector
    public let end: Vector
    
    public var corners: [Vector] { [start,
                                    Vector(x: end.x, y: start.y, z: 0),
                                    end,
                                    Vector(x: start.x, y: end.y, z: 0)] }
    
    public var edges: [Vector] { Ordinal.allCases.map { corners[$0.corner].lerp(corners[($0.corner + 1) % 4], 0.5) } }
    
    public var center: Vector { (start + end) / 2.0 }
    
    public init(start: Vector, end: Vector) {
        
        self.start = Vector.minimum(lhs: start, rhs: end)
        self.end = Vector.maximum(lhs: start, rhs: end)
    }
}
