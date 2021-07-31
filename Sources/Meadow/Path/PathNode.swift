//
//  PathNode.swift
//
//  Created by Zack Brown on 02/04/2021.
//

import Euclid

public struct PathNode: Equatable {
    
    public let coordinate: Coordinate
    public let vector: Vector
    public let direction: Cardinal
    public let movementCost: Double
    public let sloped: Bool
}
