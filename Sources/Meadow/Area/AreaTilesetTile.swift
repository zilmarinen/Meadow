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
        case weighting
        case uvs
    }
    
    var tileType: AreaTileType
    var pattern: Pattern
    var weighting: GridTileWeighting
    var uvs: UVs?

    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        tileType = try container.decode(AreaTileType.self, forKey: .tileType)
        pattern = try container.decode(Pattern.self, forKey: .pattern)
        weighting = try container.decode(GridTileWeighting.self, forKey: .weighting)
        uvs = try container.decode(UVs.self, forKey: .uvs)
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(tileType, forKey: .tileType)
        try container.encode(pattern, forKey: .pattern)
        try container.encodeIfPresent(uvs, forKey: .uvs)
        try container.encode(weighting, forKey: .weighting)
    }
}
