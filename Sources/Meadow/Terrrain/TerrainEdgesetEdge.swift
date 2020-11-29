//
//  TerrainEdgesetEdge.swift
//
//  Created by Zack Brown on 26/11/2020.
//

import Foundation

struct TerrainEdgesetEdge: Decodable, Equatable {
 
    enum CodingKeys: CodingKey {
        
        case tileType
        case uvs
    }
    
    var tileType: TerrainTileType
    var uvs: UVs?

    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        tileType = try container.decode(TerrainTileType.self, forKey: .tileType)
        uvs = try container.decode(UVs.self, forKey: .uvs)
    }
}
