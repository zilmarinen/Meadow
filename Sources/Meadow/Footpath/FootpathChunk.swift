//
//  FootpathChunk.swift
//
//  Created by Zack Brown on 25/03/2021.
//

import SceneKit

public class FootpathChunk: Chunk<FootpathTile> {
    
    public override var category: Int { SceneGraphCategory.surfaceChunk.rawValue }
    
    override var program: SCNProgram? {
        
        guard let library = scene?.library else { return nil }
        
        return SCNProgram(name: "footpath", library: library)
    }
    
    override var uniforms: [Uniform]? { nil }
    
    override var textures: [Texture]? {
        
        guard let tilemap = scene?.meadow.footpath.tilemap else { return [] }
        
        return [Texture(key: "tileset", image: tilemap.tileset.image)]
    }
}
