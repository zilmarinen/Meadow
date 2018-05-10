//
//  TerrainTile.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public class TerrainTile: GridTile<TerrainNode> {
    
    override var geometry: SCNGeometry {
        
        return SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 1.0)
    }
}
