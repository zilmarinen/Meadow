//
//  WaterChunk.swift
//
//  Created by Zack Brown on 26/03/2021.
//

import SceneKit

public class WaterChunk: Chunk<WaterTile> {
    
    public override var category: Int { SceneGraphCategory.surfaceChunk.rawValue }
    
    override var program: SCNProgram? { scene?.meadow.water.program }
    
    override var uniforms: [Uniform]? { nil }
    
    override var textures: [Texture]? { nil }
}

