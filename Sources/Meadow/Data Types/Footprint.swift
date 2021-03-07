//
//  Footprint.swift
//
//  Created by Zack Brown on 07/12/2020.
//

public struct Footprint: Codable {
    
    let coordinate: Coordinate
    
    var rotation: Cardinal
    
    let nodes: [FootprintNode]
    
    var pointsOfAccess: [GridNode] {
        
        return nodes.flatMap { node in
            
            node.cardinals.compactMap { (cardinal, pointOfAccess) in
                
                return pointOfAccess ? GridNode(coordinate: coordinate + node.coordinate, cardinal: cardinal) : nil
            }
        }
    }
    
    public init(coordinate: Coordinate, rotation: Cardinal, nodes: [FootprintNode]) {
        
        self.coordinate = coordinate
        self.rotation = rotation
        
        self.nodes = nodes.map { node in
            
            let nodeCoordinate = node.coordinate.rotate(rotation: rotation)
            
            var rotated: [Cardinal : Bool] = [:]
            
            for (cardinal, pointOfAccess) in node.cardinals {
                
                rotated[cardinal.rotate(rotation: rotation)] = pointOfAccess
            }
            
            return FootprintNode(coordinate: coordinate + nodeCoordinate, cardinals: rotated)
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
