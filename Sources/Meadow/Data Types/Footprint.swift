//
//  Footprint.swift
//
//  Created by Zack Brown on 07/12/2020.
//

import Foundation

public struct Footprint: Codable, Equatable {
    
    private enum CodingKeys: String, CodingKey {
        
        case coordinate = "c"
        case rotation = "r"
        case nodes = "n"
    }
    
    public let coordinate: Coordinate
    
    public let rotation: Cardinal
    
    public let nodes: [Coordinate]
    
    public let bounds: GridBounds
    
    public init(coordinate: Coordinate, rotation: Cardinal = .north, nodes: [Coordinate]) {
        
        self.coordinate = coordinate
        self.rotation = rotation
        self.nodes = nodes.map { $0.rotate(rotation: rotation) + coordinate }
        self.bounds = GridBounds(nodes: nodes)
    }
    
    public init(bounds: GridBounds, rotation: Cardinal = .north) {
        
        var nodes: [Coordinate] = []
        
        for x in 0..<bounds.size.x {
            
            for z in 0..<bounds.size.z {
                
                nodes.append(Coordinate(x: x, y: 0, z: z))
            }
        }
        
        self.init(coordinate: bounds.start, rotation: rotation, nodes: nodes)
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        coordinate = try container.decode(Coordinate.self, forKey: .coordinate)
        rotation = try container.decode(Cardinal.self, forKey: .rotation)
        nodes = try container.decode([Coordinate].self, forKey: .nodes)
        
        self.bounds = GridBounds(nodes: nodes)
    }

    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(coordinate, forKey: .coordinate)
        try container.encode(rotation, forKey: .rotation)
        try container.encode(nodes, forKey: .nodes)
    }
}

extension Footprint {
    
    public func intersects(footprint: Footprint) -> Bool {
        
        for node in footprint.nodes {
            
            if intersects(coordinate: node) {
                
                return true
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

extension Footprint {
    
    public static func == (lhs: Footprint, rhs: Footprint) -> Bool {
        
        return lhs.coordinate == rhs.coordinate && lhs.rotation == rhs.rotation && lhs.nodes == rhs.nodes
    }
}
