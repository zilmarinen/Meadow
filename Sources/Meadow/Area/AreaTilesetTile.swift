//
//  AreaTilesetTile.swift
//
//  Created by Zack Brown on 08/12/2020.
//

import Foundation

struct AreaTilesetTile: Decodable, Equatable {
    
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
}
