//
//  WaterChunk.swift
//
//  Created by Zack Brown on 26/03/2021.
//

import SceneKit

public class WaterChunk: Chunk<WaterTile> {
    
    public override var category: Int { SceneGraphCategory.surfaceChunk.rawValue }
    
    public override var program: SCNProgram? { scene?.meadow.water.program }
    
    public override var uniforms: [Uniform]? { nil }
    
    public override var textures: [Texture]? { nil }
}
