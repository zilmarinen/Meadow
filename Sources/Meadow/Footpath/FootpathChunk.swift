//
//  FootpathChunk.swift
//
//  Created by Zack Brown on 25/03/2021.
//

import SceneKit

public class FootpathChunk: Chunk<FootpathTile> {
    
    public override var category: SceneGraphCategory { .surfaceChunk }
    
    public override var program: SCNProgram? { map?.footpath.program }
    
    public override var uniforms: [Uniform]? { nil }
    
    public override var textures: [Texture]? {
        
        guard let tilemap = map?.footpath.tilemap else { return [] }
        
        return [Texture(key: "image", image: tilemap.tileset.image)]
    }
}
