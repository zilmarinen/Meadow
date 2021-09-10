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
        
        guard let tilemap = map?.surface.tilemap,
              let dirt = MDWImage.asset(named: "surface_dirt", in: .module),
              let sand = MDWImage.asset(named: "surface_sand", in: .module),
              let stone = MDWImage.asset(named: "surface_stone", in: .module),
              let wood = MDWImage.asset(named: "surface_wood", in: .module) else { return [] }
        
        return [Texture(key: "edgeset", image: tilemap.edgeset.image),
                Texture(key: "tileset", image: tilemap.tileset.image),
                Texture(key: "dirt", image: dirt),
                Texture(key: "sand", image: sand),
                Texture(key: "stone", image: stone),
                Texture(key: "wood", image: wood)]
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
