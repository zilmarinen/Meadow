//
//  TilesetTile.swift
//
//  Created by Zack Brown on 24/03/2021.
//

import Foundation

public class TilesetTile: Codable, Equatable {
    
    private enum CodingKeys: String, CodingKey {
        
        case pattern = "p"
        case uvs = "uv"
    }
    
    public let pattern: Int
    public let uvs: UVs
}

extension TilesetTile {
    
    public static func == (lhs: TilesetTile, rhs: TilesetTile) -> Bool {
        
        return lhs.pattern == rhs.pattern && lhs.uvs == rhs.uvs
    }
}
