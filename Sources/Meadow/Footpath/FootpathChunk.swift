//
//  FootpathChunk.swift
//
//  Created by Zack Brown on 27/11/2020.
//

import SceneKit

public class FootpathChunk: Chunk<FootpathTile> {
    
    public override var category: Int { SceneGraphCategory.footpathChunk.rawValue }
    
    override var program: SCNProgram? {
        
        guard let library = scene?.library else { return nil }
        
        return SCNProgram(name: "footpath", library: library)
    }
    
    override var uniforms: [Uniform]? { nil }
    
    override var textures: [Texture]? {
        
        guard let tilemap = scene?.world.tilemaps.footpath else { return [] }
        
        return [Texture(key: "tilemap", image: tilemap.image)]
    }
}
