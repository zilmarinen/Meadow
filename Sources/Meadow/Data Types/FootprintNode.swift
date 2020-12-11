//
//  FootprintNode.swift
//
//  Created by Zack Brown on 07/12/2020.
//

public struct FootprintNode: Codable {
    
    let coordinate: Coordinate
    
    let cardinals: [Cardinal]
}

extension FootprintNode {
    
    func intersects(node: FootprintNode) -> Bool {
        
        guard coordinate == node.coordinate else { return false }
        
        for lhs in cardinals {
            
            for rhs in node.cardinals {
                
                if lhs == rhs {
                    
                    return true
                }
            }
        }
        
        return false
    }
    
    func intersects(node: GridNode) -> Bool {
        
        guard coordinate == node.coordinate else { return false }
        
        return cardinals.contains(node.cardinal)
    }
}
