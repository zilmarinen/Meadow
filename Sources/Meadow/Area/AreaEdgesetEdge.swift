//
//  AreaEdgesetEdge.swift
//
//  Created by Zack Brown on 08/12/2020.
//

import Foundation

struct AreaEdgesetEdge: Decodable, Equatable {
 
    enum CodingKeys: CodingKey {
        
        case tileType
        case uvs
    }
    
    var tileType: AreaTileType
    var uvs: UVs

    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        tileType = try container.decode(AreaTileType.self, forKey: .tileType)
        uvs = try container.decode(UVs.self, forKey: .uvs)
    }
}
