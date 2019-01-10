//
//  Footprint.swift
//  Meadow
//
//  Created by Zack Brown on 14/11/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public struct Footprint: Codable, Hashable {
    
    public let coordinate: Coordinate
    
    public let rotation: GridEdge
    
    public let nodes: [FootprintNode]
    
    init(coordinate: Coordinate, rotation: GridEdge, nodes: [FootprintNode]) {
        
        self.coordinate = coordinate
        self.rotation = rotation
        
        self.nodes = nodes.map { node -> FootprintNode in
            
            let nodeCoordinate = Coordinate.rotate(coordinate: (node.coordinate + coordinate), rotation: rotation)
            
            let edges = node.edges.map { GridEdge.rotate(edge: $0, rotation: rotation) }
            
            return FootprintNode(coordinate: nodeCoordinate, edges: edges)
        }
    }
}

extension Footprint {
    
    func intersects(footprint: Footprint) -> Bool {
        
        for i in 0..<nodes.count {
            
            let lhs = nodes[i]
            
            for j in 0..<footprint.nodes.count {
                
                let rhs = footprint.nodes[j]
                
                if lhs.intersects(node: rhs) {
                    
                    return true
                }
            }
        }
        
        return false
    }
    
    public func intersects(coordinate: Coordinate, edge: GridEdge) -> Bool {
        
        let node = FootprintNode(coordinate: coordinate, edges: [edge])
        
        return intersects(footprint: Footprint(coordinate: coordinate, rotation: .north, nodes: [node]))
    }
}
