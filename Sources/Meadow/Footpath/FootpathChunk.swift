//
//  FootpathChunk.swift
//
//  Created by Zack Brown on 25/03/2021.
//

import SceneKit

public class FootpathChunk: Chunk<FootpathTile> {
    
    public override var category: Int { SceneGraphCategory.surfaceChunk.rawValue }
    
    public override var program: SCNProgram? { scene?.map.footpath.program }
    
    public override var uniforms: [Uniform]? { nil }
    
    public override var textures: [Texture]? {
        
        guard let tilemap = scene?.map.footpath.tilemap else { return [] }
        
        return [Texture(key: "tileset", image: tilemap.tileset.image)]
    }
}
