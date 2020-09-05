//
//  LayeredGrid.swift
//  Meadow
//
//  Created by Zack Brown on 24/06/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Pasture

public class LayeredGrid<C: Chunk<T>, T: LayeredTile<E, L>, E: Edge<L>, L:Layer>: Grid<C, T> {
    
    public override func add(tile identifier: Int) -> T? {
        
        guard let tile = super.add(tile: identifier) else { return nil }
        
        for edge in tile.joints {
            
            if tile.find(edge: edge) == nil {
                
                let _ = tile.add(edge: edge)
            }
        }
        
        return tile
    }
    
    public func add(layer tileIdentifier: Int, edgeIdentifier: Int) -> L? {
        
        guard let tile = find(tile: tileIdentifier) ?? super.add(tile: tileIdentifier) else { return nil }
        
        if let edge = tile.find(edge: edgeIdentifier) {
            
            return edge.addLayer()
        }
        
        return tile.add(edge: edgeIdentifier).topLayer
    }
}
