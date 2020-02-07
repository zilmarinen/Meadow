//
//  Neighbour.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

protocol Neighbour: Soilable {
    
    associatedtype N: Neighbour
    
    var neighbours: [Cardinal : N] { get set }
    
    func add(neighbour: N, cardinal: Cardinal)
    func find(neighbour cardinal: Cardinal) -> Self?
    func remove(neighbour cardinal: Cardinal)
}

extension Neighbour {
    
    func add(neighbour: N, cardinal: Cardinal) {
        
        remove(neighbour: cardinal)
        
        neighbours.updateValue(neighbour, forKey: cardinal)
        
        becomeDirty()
        
        if let this = self as? N.N, neighbour.neighbours[cardinal.opposite] == nil {
            
            neighbour.add(neighbour: this, cardinal: cardinal.opposite)
        }
    }
    
    func find(neighbour cardinal: Cardinal) -> Self? {
        
        return neighbours[cardinal] as? Self
    }
    
    func remove(neighbour cardinal: Cardinal) {
        
        if let neighbour = find(neighbour: cardinal) {
            
            neighbours.removeValue(forKey: cardinal)
            
            becomeDirty()
            
            if neighbour.neighbours[cardinal.opposite] != nil {
                
                neighbour.remove(neighbour: cardinal.opposite)
            }
        }
    }
}
