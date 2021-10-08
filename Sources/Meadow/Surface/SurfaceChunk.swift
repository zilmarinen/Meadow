//
//  SurfaceChunk.swift
//
//  Created by Zack Brown on 23/12/2020.
//

import Euclid
import SceneKit

public class SurfaceChunk: Chunk<SurfaceTile> {
    
    private enum CodingKeys: String, CodingKey {
        
        case mesh = "m"
    }
    
    public override var category: SceneGraphCategory { .surfaceChunk }
    
    public override var program: SCNProgram? { map?.surface.program }
    
    public override var uniforms: [Uniform]? { nil }
    
    public override var textures: [Texture]? {
        
        guard let tileset = scene?.atlas.surface else { return nil }
        
        return [tileset.overlay] + tileset.materials
    }
    
    required public init(from decoder: Decoder) throws {
        
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let mesh = try container.decode(Mesh.self, forKey: .mesh)
        
        self.geometry = SCNGeometry(mesh)
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
