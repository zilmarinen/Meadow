//
//  FootpathTile.swift
//
//  Created by Zack Brown on 25/03/2021.
//

import Euclid
import SceneKit

public class FootpathTile: Tile {
    
    private enum CodingKeys: String, CodingKey {
        
        case material = "m"
        case pattern = "p"
    }
    
    public override var category: SceneGraphCategory { .footpathTile }

    let material: FootpathMaterial
    let pattern: Int

    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        material = try container.decode(FootpathMaterial.self, forKey: .material)
        pattern = try container.decode(Int.self, forKey: .pattern)
        
        try super.init(from: decoder)
    }
}

extension FootpathTile {
    
    public static func == (lhs: FootpathTile, rhs: FootpathTile) -> Bool {
        
        return lhs.coordinate == rhs.coordinate && lhs.pattern == rhs.pattern && lhs.material == rhs.material
    }
}
