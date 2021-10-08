//
//  WaterTile.swift
//
//  Created by Zack Brown on 26/03/2021.
//

import Euclid
import SceneKit

public class WaterTile: Tile {
    
    private enum CodingKeys: String, CodingKey {
        
        case material = "m"
    }
    
    public override var category: SceneGraphCategory { .waterTile }

    let material: WaterMaterial

    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        material = try container.decode(WaterMaterial.self, forKey: .material)
        
        try super.init(from: decoder)
    }
}

extension WaterTile {
    
    public static func == (lhs: WaterTile, rhs: WaterTile) -> Bool {
        
        return lhs.coordinate == rhs.coordinate && lhs.material == rhs.material
    }
}
