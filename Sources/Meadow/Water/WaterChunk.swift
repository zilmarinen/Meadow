//
//  WaterChunk.swift
//
//  Created by Zack Brown on 26/03/2021.
//

import SceneKit

public class WaterChunk: Chunk<WaterTile> {
    
    public override var category: SceneGraphCategory { .surfaceChunk }
    
    public override var program: SCNProgram? { map?.water.program }
    
    public override var uniforms: [Uniform]? { nil }
    
    public override var textures: [Texture]? { nil }
}
