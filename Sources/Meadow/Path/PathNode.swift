//
//  PathNode.swift
//
//  Created by Zack Brown on 02/04/2021.
//

import Euclid

public struct PathNode: Equatable {
    
    public let coordinate: Coordinate
    public let position: Vector
    public let direction: Vector
    public let movementCost: Double
    public let sloped: Bool
}
