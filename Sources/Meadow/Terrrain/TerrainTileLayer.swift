//
//  TerrainTileLayer.swift
//
//  Created by Zack Brown on 23/11/2020.
//

import Foundation

public struct TerrainTileLayer: Codable, Equatable {
    
    enum CodingKeys: CodingKey {
        
        case tileType
        case slope
    }
    
    var tileType: TerrainTileType = .water
    public var slope: Cardinal? = nil
    
    var tilesetTile: TerrainTilesetTile? = nil
    
    init(tileType: TerrainTileType, slope: Cardinal? = nil) {
        
        self.tileType = tileType
        self.slope = slope
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        tileType = try container.decode(TerrainTileType.self, forKey: .tileType)
        slope = try container.decode(Cardinal.self, forKey: .slope)
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(tileType, forKey: .tileType)
        try container.encode(slope, forKey: .slope)
    }
}
