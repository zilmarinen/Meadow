//
//  Traversable.swift
//
//  Created by Zack Brown on 02/04/2021.
//

protocol Traversable {
    
    var movementCost: Double { get }
    var walkable: Bool { get }
    
    func traversableNode(for coordinate: Coordinate) -> TraversableNode
}
