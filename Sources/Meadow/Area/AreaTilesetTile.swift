//
//  AreaTilesetTile.swift
//
//  Created by Zack Brown on 08/12/2020.
//

import Foundation

struct AreaTilesetTile: Codable, Equatable {
    
    enum CodingKeys: CodingKey {
        
        case tileType
        case pattern
        case rarity
        case uvs
    }
    
    var tileType: AreaTileType
    var pattern: GridPattern
    var rarity: Rarity
    var uvs: UVs

    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        tileType = try container.decode(AreaTileType.self, forKey: .tileType)
        pattern = try container.decode(GridPattern.self, forKey: .pattern)
        rarity = try container.decode(Rarity.self, forKey: .rarity)
        uvs = try container.decode(UVs.self, forKey: .uvs)
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(tileType, forKey: .tileType)
        try container.encode(pattern, forKey: .pattern)
        try container.encode(uvs, forKey: .uvs)
        try container.encode(rarity, forKey: .rarity)
    }
}
