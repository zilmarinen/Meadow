//
//  TraversableNode.swift
//
//  Created by Zack Brown on 06/06/2021.
//

public struct TraversableNode: Equatable {
    
    public let coordinate: Coordinate
    public let vector: Vector
    public let movementCost: Double
    public let sloped: Bool
    public let cardinals: [Cardinal]
}
