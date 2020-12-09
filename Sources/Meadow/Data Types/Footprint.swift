//
//  Footprint.swift
//
//  Created by Zack Brown on 07/12/2020.
//

public struct Footprint: Codable {
    
    let coordinate: Coordinate
    
    var rotation: Cardinal
    
    let nodes: [FootprintNode]
    
    init(coordinate: Coordinate, rotation: Cardinal, nodes: [FootprintNode]) {
        
        self.coordinate = coordinate
        self.rotation = rotation
        
        self.nodes = nodes.map { node in
            
            let nodeCoordinate = node.coordinate.rotate(rotation: rotation)
                        
            let cardinals = node.cardinals.map { $0.rotate(rotation: rotation) }
            
            return FootprintNode(coordinate: coordinate + nodeCoordinate, cardinals: cardinals)
        }
    }
}

extension Footprint {
    
    func intersects(footprint: Footprint) -> Bool {
        
        for lhs in nodes {
            
            for rhs in footprint.nodes {
                
                if lhs.intersects(node: rhs) {
                    
                    return true
                }
            }
        }
        
        return false
    }
    
    func intersects(node: GridNode) -> Bool {
        
        for lhs in nodes {
                
            if lhs.intersects(node: node) {
                
                return true
            }
        }
        
        return false
    }
}
