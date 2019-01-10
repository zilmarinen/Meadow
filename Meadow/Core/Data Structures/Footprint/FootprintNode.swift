//
//  FootprintNode.swift
//  Meadow
//
//  Created by Zack Brown on 14/11/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public struct FootprintNode: Codable, Hashable {
    
    public let coordinate: Coordinate
    
    public let edges: [GridEdge]
    
    init(coordinate: Coordinate, edges: [GridEdge]) {
        
        self.coordinate = coordinate
        self.edges = edges
    }
}

extension FootprintNode {
    
    func intersects(node: FootprintNode) -> Bool {
        
        if coordinate == node.coordinate {
            
            for i in 0..<edges.count {
                
                let lhs = edges[i]
                
                for j in 0..<node.edges.count {
                    
                    let rhs = node.edges[j]
                    
                    if lhs == rhs {
                        
                        return true
                    }
                }
            }
        }
        
        return false
    }
}
