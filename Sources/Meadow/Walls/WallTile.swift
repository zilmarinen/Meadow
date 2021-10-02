//
//  WallTile.swift
//
//  Created by Zack Brown on 09/08/2021.
//

import Euclid
import SceneKit

public class WallTile: Tile {
    
    private enum CodingKeys: String, CodingKey {
        
        case tileType = "t"
        case pattern = "p"
        case material = "m"
        case external = "e"
    }
    
    public override var category: SceneGraphCategory { .wallTile }
    
    var prop: Prop { .wall(tileType: tileType, material: material, pattern: pattern, external: external) }

    let tileType: WallTileType
    let material: WallTileMaterial
    let pattern: Cardinal
    let external: Bool

    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        tileType = try container.decode(WallTileType.self, forKey: .tileType)
        material = try container.decode(WallTileMaterial.self, forKey: .material)
        pattern = try container.decode(Cardinal.self, forKey: .pattern)
        external = try container.decode(Bool.self, forKey: .external)
        
        try super.init(from: decoder)
    }
}

extension WallTile {
    
    public static func == (lhs: WallTile, rhs: WallTile) -> Bool {
        
        return lhs.coordinate == rhs.coordinate && lhs.tileType == rhs.tileType
    }
}
