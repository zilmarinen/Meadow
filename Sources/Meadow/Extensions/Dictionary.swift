//
//  Dictionary.swift
//
//  Created by Zack Brown on 25/05/2021.
//

import Foundation

public extension Dictionary where Key == Ordinal, Value == TileVolume {
    
    func apex() -> [Int] {
        
        return Ordinal.allCases.compactMap { Int(Double(World.Constants.ceiling) * self[$0]!.apex.corners[$0.rawValue]) }
    }
}

extension Dictionary where Key == Coordinate, Value == TraversableNode {
    
    func path(between origin: Coordinate, destination: Coordinate) -> [PathNode]? {
        
        guard let end = self[destination],
              self[origin] != nil else { return nil }
        
        var nodes: [PathNode] = [PathNode(coordinate: end.coordinate, vector: end.vector, direction: .north, movementCost: end.movementCost, sloped: end.sloped)]
        
        var node = end
        
        while node.coordinate != origin {
            
            guard let next = self[node.coordinate] else { return nil }
            
            nodes.append(PathNode(coordinate: next.coordinate, vector: next.vector, direction: next.coordinate.direction(to: next.coordinate), movementCost: next.movementCost, sloped: next.sloped))
            
            node = next
        }
        
        return nodes
    }
}
