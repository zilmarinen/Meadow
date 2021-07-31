//
//  SurfaceChunk.swift
//
//  Created by Zack Brown on 23/12/2020.
//

import SceneKit

public class SurfaceChunk: Chunk<SurfaceTile> {
    
    public override var category: Int { SceneGraphCategory.surfaceChunk.rawValue }
    
    public override var program: SCNProgram? { scene?.meadow.surface.program }
    
    public override var uniforms: [Uniform]? { nil }
    
    public override var textures: [Texture]? {
        
        guard let tilemap = scene?.meadow.surface.tilemap else { return [] }
        
        return [Texture(key: "edgeset", image: tilemap.edgeset.image),
                Texture(key: "tileset", image: tilemap.tileset.image)]
    }
}
