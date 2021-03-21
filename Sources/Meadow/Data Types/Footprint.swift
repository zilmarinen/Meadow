//
//  Footprint.swift
//
//  Created by Zack Brown on 07/12/2020.
//

public struct Footprint: Codable, Equatable {
    
    public let coordinate: Coordinate
    
    var rotation: Cardinal
    
    public let nodes: [Coordinate]
    
    public init(coordinate: Coordinate, rotation: Cardinal, nodes: [Coordinate]) {
        
        self.coordinate = coordinate
        self.rotation = rotation
        
        self.nodes = nodes.map { $0.rotate(rotation: rotation) + coordinate }
    }
}

extension Footprint {
    
    public func intersects(footprint: Footprint) -> Bool {
        
        for lhs in nodes {
            
            for rhs in footprint.nodes {
                
                if lhs.xz == rhs.xz {
                    
                    return true
                }
            }
        }
        
        return false
    }
    
    public func intersects(coordinate: Coordinate) -> Bool {
        
        for lhs in nodes {
                
            if lhs.xz == coordinate.xz {
                
                return true
            }
        }
        
        return false
    }
}
