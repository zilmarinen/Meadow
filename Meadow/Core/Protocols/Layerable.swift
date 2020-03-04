//
//  Layerable.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

protocol Layerable: Tile {
    
    associatedtype E: Soilable
    
    var edges: [Cardinal: E] { get set }
    
    func add(edge cardinal: Cardinal, configurator: Layer.Configurator) -> E
    func find(edge cardinal: Cardinal) -> E?
    func remove(edge cardinal: Cardinal)
}

extension Layerable {
    
    func find(edge cardinal: Cardinal) -> E? {
        
        return edges[cardinal]
    }
    
    func remove(edge cardinal: Cardinal) {
        
        if find(edge: cardinal) != nil {
            
            edges.removeValue(forKey: cardinal)
            
            becomeDirty()
            
            if let neighbour = find(neighbour: cardinal), let connectedEdge = neighbour.find(edge: cardinal.opposite) {
                
                connectedEdge.becomeDirty()
            }
        }
    }
}
