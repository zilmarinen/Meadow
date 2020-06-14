//
//  Layerable.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

public protocol Layerable: Tile {
    
    associatedtype E: Soilable
    
    var edges: [Cardinal: E] { get set }
    
    func add(edge cardinal: Cardinal) -> E
    func find(edge cardinal: Cardinal) -> E?
    func remove(edge cardinal: Cardinal)
}

extension Layerable {
    
    public func find(edge cardinal: Cardinal) -> E? {
        
        return edges[cardinal]
    }
    
    public func remove(edge cardinal: Cardinal) {
        
        if find(edge: cardinal) != nil {
            
            edges.removeValue(forKey: cardinal)
            
            becomeDirty()
            
            if let neighbour = find(neighbour: cardinal), let connectedEdge = neighbour.find(edge: cardinal.opposite) {
                
                connectedEdge.becomeDirty()
            }
        }
    }
}
