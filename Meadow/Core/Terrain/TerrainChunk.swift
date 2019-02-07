//
//  TerrainChunk.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.

import SceneKit

public class TerrainChunk: GridChunk<TerrainTile, TerrainNode<TerrainNodeEdge<TerrainEdgeLayer>>> {
 
    @discardableResult public override func clean() -> Bool {
        
        let wasDirty = super.clean()
        
        if wasDirty {
        
            if geometry?.program == nil {
                
                geometry?.program = ShaderProgram(named: "terrain")
            }
        }
        
        return wasDirty
    }
}
