//
//  Terrain.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation

public class Terrain: Grid<TerrainChunk, TerrainTile, TerrainNode<TerrainLayer>> {
    
}

extension Terrain {
    
    func add(node coordinate: Coordinate) -> TerrainNode<TerrainLayer>? {
        
        return add(node: TerrainTile.fixedVolume(coordinate))
    }
}
