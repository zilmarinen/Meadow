//
//  WallChunk.swift
//
//  Created by Zack Brown on 09/08/2021.
//

import Euclid
import SceneKit

public class WallChunk: Chunk<WallTile> {
    
    public override var category: SceneGraphCategory { .wallChunk }
    
    public override var program: SCNProgram? { map?.walls.program }
}
