//
//  TerrainTilesetTile.swift
//
//  Created by Zack Brown on 16/11/2020.
//

import Foundation

struct TerrainTilesetTile: Decodable {
    
    enum CodingKeys: CodingKey {
        
        case tileType
        case pattern
        case rarity
        case uvs
    }
    
    var tileType: TerrainTileType
    var pattern: GridPattern
    var rarity: Rarity
    var uvs: UVs

    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        tileType = try container.decode(TerrainTileType.self, forKey: .tileType)
        pattern = try container.decode(GridPattern.self, forKey: .pattern)
        rarity = try container.decode(Rarity.self, forKey: .rarity)
        uvs = try container.decode(UVs.self, forKey: .uvs)
    }
}
