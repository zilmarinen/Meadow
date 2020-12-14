//
//  FootpathTilesetTile.swift
//
//  Created by Zack Brown on 27/11/2020.
//

import Foundation

struct FootpathTilesetTile: Decodable, Equatable {
    
    enum CodingKeys: CodingKey {
        
        case tileType
        case pattern
        case uvs
    }
    
    var tileType: FootpathTileType
    var pattern: GridPattern
    var uvs: UVs

    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        tileType = try container.decode(FootpathTileType.self, forKey: .tileType)
        pattern = try container.decode(GridPattern.self, forKey: .pattern)
        uvs = try container.decode(UVs.self, forKey: .uvs)
    }
}
