//
//  SurfaceTilesetTile.swift
//
//  Created by Zack Brown on 16/11/2020.
//

import Foundation

public struct SurfaceTilesetTile: Codable, Equatable {
    
    enum CodingKeys: CodingKey {
        
        case tileType
        case uvs
    }
    
    var tileType: SurfaceTileType
    var uvs: UVs
}
