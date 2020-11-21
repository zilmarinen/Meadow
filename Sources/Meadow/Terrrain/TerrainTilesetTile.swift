//
//  TerrainTilesetTile.swift
//
//  Created by Zack Brown on 16/11/2020.
//

import CoreGraphics
import Foundation

struct TerrainTilesetTile: Decodable {
    
    enum CodingKeys: CodingKey {
        
        case tileType
        case pattern
        case weighting
        case uvs
    }
    
    struct UVs: Codable {
        
        let start: CGPoint
        let end: CGPoint
        
        var uvs: [CGPoint] {
            
            return [CGPoint(x: start.x, y: end.y),
                    CGPoint(x: end.x, y: end.y),
                    CGPoint(x: end.x, y: start.y),
                    CGPoint(x: start.x, y: start.y)]
        }
    }
    
    var tileType: TerrainTileType
    var pattern: TerrainTilePattern
    var weighting: TerrainTileWeighting
    var uvs: UVs?

    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        tileType = try container.decode(TerrainTileType.self, forKey: .tileType)
        pattern = try container.decode(TerrainTilePattern.self, forKey: .pattern)
        weighting = try container.decode(TerrainTileWeighting.self, forKey: .weighting)
        uvs = try container.decode(UVs.self, forKey: .uvs)
    }
}
