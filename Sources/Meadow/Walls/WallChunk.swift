//
//  WallChunk.swift
//
//  Created by Zack Brown on 09/08/2021.
//

import SceneKit

public class WallChunk: Chunk<WallTile> {
    
    public override var category: Int { SceneGraphCategory.wallChunk.rawValue }
    
    public override var program: SCNProgram? { scene?.map.walls.program }
    
    public override var uniforms: [Uniform]? { nil }
    
    public override var textures: [Texture]? {
        
        guard let image = MDWImage.asset(named: "walls", in: .module) else { return nil }
        
        return [Texture(key: "wall", image: image)]
    }
}
