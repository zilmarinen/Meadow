//
//  WaterChunk.swift
//
//  Created by Zack Brown on 26/03/2021.
//

import SceneKit

public class WaterChunk: Chunk<WaterTile> {
    
    public override var category: Int { SceneGraphCategory.surfaceChunk.rawValue }
    
    override var program: SCNProgram? {
        
        guard let library = scene?.library else { return nil }
        
        let program = SCNProgram(name: "water", library: library)
        
        program.isOpaque = false
        
        return program
    }
    
    override var uniforms: [Uniform]? { nil }
    
    override var textures: [Texture]? { nil }
}

