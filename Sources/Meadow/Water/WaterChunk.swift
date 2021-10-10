//
//  WaterChunk.swift
//
//  Created by Zack Brown on 26/03/2021.
//

import Euclid
import SceneKit

public class WaterChunk: Chunk<WaterTile> {
    
    private enum CodingKeys: String, CodingKey {
        
        case mesh = "m"
    }
    
    public override var category: SceneGraphCategory { .waterChunk }
    
    public override var program: SCNProgram? { map?.water.program }
    
    public override var textures: [Texture]? { nil }
    
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
