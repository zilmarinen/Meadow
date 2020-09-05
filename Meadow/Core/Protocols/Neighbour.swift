//
//  Neighbour.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

protocol Neighbour: Soilable {
    
    associatedtype N: Neighbour
    
    var neighbours: [Int : N] { get set }
    
    func add(neighbour: N, identifier: Int)
    func find(neighbour identifier: Int) -> Self?
    func remove(neighbour identifier: Int)
}

extension Neighbour {
    
    func add(neighbour: N, identifier: Int) {
        
        remove(neighbour: identifier)
        
        neighbours.updateValue(neighbour, forKey: identifier)
        
        becomeDirty()
        
        if let this = self as? N.N, neighbour.neighbours[identifier] == nil {
            
            neighbour.add(neighbour: this, identifier: identifier)
        }
    }
    
    func find(neighbour identifier: Int) -> Self? {
        
        return neighbours[identifier] as? Self
    }
    
    func remove(neighbour identifier: Int) {
        
        if let neighbour = find(neighbour: identifier) {
            
            neighbours.removeValue(forKey: identifier)
            
            becomeDirty()
            
            if neighbour.neighbours[identifier] != nil {
                
                neighbour.remove(neighbour: identifier)
            }
        }
    }
}
