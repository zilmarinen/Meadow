//
//  Dictionary.swift
//
//  Created by Zack Brown on 25/05/2021.
//

import Foundation

extension Dictionary where Key == Coordinate, Value == TraversableNode {
    
    func path(between origin: Coordinate, destination: Coordinate) -> [PathNode]? {
        
        guard let end = self[destination],
              let next = self[end.coordinate],
              self[origin] != nil else { return nil }
        
        var nodes: [PathNode] = [PathNode(coordinate: end.coordinate, vector: end.vector, direction: end.coordinate.direction(to: next.coordinate), movementCost: end.movementCost, sloped: end.sloped)]
        
        var node = end
        
        while node.coordinate != origin {
            
            guard let next = self[node.coordinate] else { return nil }
            
            nodes.append(PathNode(coordinate: next.coordinate, vector: next.vector, direction: node.coordinate.direction(to: next.coordinate), movementCost: next.movementCost, sloped: next.sloped))
            
            node = next
        }
        
        return nodes
    }
}
