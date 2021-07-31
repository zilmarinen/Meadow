//
//  TraversableNode.swift
//
//  Created by Zack Brown on 06/06/2021.
//

import Euclid

public struct TraversableNode: Equatable {
    
    public let coordinate: Coordinate
    public let vector: Vector
    public let movementCost: Double
    public let sloped: Bool
    public let cardinals: [Cardinal]
}

extension TraversableNode {
    
    func traversable(node: TraversableNode, along cardinal: Cardinal) -> Bool {
        
        let incline = abs(node.coordinate.y - coordinate.y)
        
        return node.cardinals.contains(cardinal.opposite) && (incline == 0 || (incline <= World.Constants.step && (sloped || node.sloped)))
    }
}
