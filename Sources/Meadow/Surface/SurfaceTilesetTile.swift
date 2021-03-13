//
//  SurfaceTilesetTile.swift
//
//  Created by Zack Brown on 16/11/2020.
//

import Foundation

struct SurfaceTilesetTile: Decodable, Equatable {
    
    enum CodingKeys: CodingKey {
        
        case tileType
        case uvs
    }
    
    var tileType: SurfaceTileType
    var uvs: UVs

    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        tileType = try container.decode(SurfaceTileType.self, forKey: .tileType)
        uvs = try container.decode(UVs.self, forKey: .uvs)
    }
}
