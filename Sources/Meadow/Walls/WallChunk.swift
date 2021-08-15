//
//  WallChunk.swift
//
//  Created by Zack Brown on 09/08/2021.
//

import SceneKit

public class WallChunk: Chunk<WallTile> {
    
    public override var category: Int { SceneGraphCategory.wallChunk.rawValue }
    
    public override var program: SCNProgram? { scene?.meadow.walls.program }
    
    public override var uniforms: [Uniform]? { nil }
    
    public override var textures: [Texture]? { nil }
}
