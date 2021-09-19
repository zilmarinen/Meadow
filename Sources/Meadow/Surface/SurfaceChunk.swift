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
        
        guard let tilemap = map?.surface.tilemap else { return [] }
        
        var assets = [Texture(key: "edgeset", image: tilemap.edgeset.image),
                        Texture(key: "tileset", image: tilemap.tileset.image)]
        
        assets.append(contentsOf: SurfaceTileType.allCases.compactMap { $0.texture })
        
        return assets
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
