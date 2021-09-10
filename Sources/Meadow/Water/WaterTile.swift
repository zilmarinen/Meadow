//
//  WaterTile.swift
//
//  Created by Zack Brown on 26/03/2021.
//

import Euclid
import SceneKit

public class WaterTile: Tile {
    
    private enum CodingKeys: String, CodingKey {
        
        case tileType = "t"
        case apexPattern = "ap"
    }
    
    public override var category: SceneGraphCategory { .waterTile }

    let tileType: WaterTileType
    let apexPattern: Int

    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        tileType = try container.decode(WaterTileType.self, forKey: .tileType)
        apexPattern = try container.decode(Int.self, forKey: .apexPattern)
        
        try super.init(from: decoder)
    }
}

extension WaterTile {
    
    public static func == (lhs: WaterTile, rhs: WaterTile) -> Bool {
        
        return lhs.coordinate == rhs.coordinate && lhs.apexPattern == rhs.apexPattern && lhs.tileType == rhs.tileType
    }
}
