//
//  UVs.swift
//
//  Created by Zack Brown on 26/11/2020.
//

import Euclid
import CoreGraphics

public struct UVs: Codable, Equatable {
    
    public static let corners: UVs = UVs(start: .origin, end: Position(x: 1, y: 1, z: 1))
    
    public let start: Position
    public let end: Position
    
    public var corners: [Position] { [start,
                                      Position(x: end.x, y: start.y, z: 0),
                                      end,
                                      Position(x: start.x, y: end.y, z: 0)] }
    
    public var edges: [Position] { Ordinal.allCases.map { corners[$0.corner].lerp(corners[($0.corner + 1) % 4], 0.5) } }
    
    public var center: Position { start.lerp(end, 0.5) }
    
    public init(start: Position, end: Position) {
        
        self.start = Position.minimum(lhs: start, rhs: end)
        self.end = Position.maximum(lhs: start, rhs: end)
    }
}
