//
//  LayeredGrid.swift
//  Meadow
//
//  Created by Zack Brown on 24/06/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

public class LayeredGrid<C: Chunk<T>, T: LayeredTile<E, L>, E: Edge<L>, L:Layer>: Grid<C, T> {
    
    public override func add(tile coordinate: Coordinate) -> T {
        
        let tile = super.add(tile: coordinate)
        
        for cardinal in Cardinal.allCases {
            
            if tile.find(edge: cardinal) == nil {
                
                let _ = tile.add(edge: cardinal)
            }
        }
        
        return tile
    }
    
    func add(layer coordinate: Coordinate, cardinal: Cardinal) -> L? {
        
        let tile = find(tile: coordinate) ?? add(tile: coordinate)
        
        if let edge = tile.find(edge: cardinal) {
            
            return edge.addLayer()
        }
        
        let edge = tile.add(edge: cardinal)
        
        return edge.topLayer
    }
}
