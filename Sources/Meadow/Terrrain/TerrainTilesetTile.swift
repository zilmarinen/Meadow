//
//  TerrainTilesetTile.swift
//
//  Created by Zack Brown on 16/11/2020.
//

import Foundation

struct TerrainTilesetTile: Decodable, Equatable {
    
    enum CodingKeys: CodingKey {
        
        case tileType
        case pattern
        case weighting
        case uvs
    }
    
    var tileType: TerrainTileType
    var pattern: Pattern
    var weighting: GridTileWeighting
    var uvs: UVs?

    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        tileType = try container.decode(TerrainTileType.self, forKey: .tileType)
        pattern = try container.decode(Pattern.self, forKey: .pattern)
        weighting = try container.decode(GridTileWeighting.self, forKey: .weighting)
        uvs = try container.decode(UVs.self, forKey: .uvs)
    }
}
