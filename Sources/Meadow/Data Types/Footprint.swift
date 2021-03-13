//
//  Footprint.swift
//
//  Created by Zack Brown on 07/12/2020.
//

public struct Footprint: Codable {
    
    let coordinate: Coordinate
    
    var rotation: Cardinal
    
    let nodes: [Coordinate]
    
    public init(coordinate: Coordinate, rotation: Cardinal, nodes: [Coordinate]) {
        
        self.coordinate = coordinate
        self.rotation = rotation
        
        self.nodes = nodes.map { $0.rotate(rotation: rotation) }
    }
}

extension Footprint {
    
    func intersects(footprint: Footprint) -> Bool {
        
        for lhs in nodes {
            
            for rhs in footprint.nodes {
                
                if lhs == rhs {
                    
                    return true
                }
            }
        }
        
        return false
    }
    
    func intersects(coordinate: Coordinate) -> Bool {
        
        for lhs in nodes {
                
            if lhs == coordinate {
                
                return true
            }
        }
        
        return false
    }
}
