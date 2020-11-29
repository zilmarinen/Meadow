//
//  FootpathTileLayer.swift
//
//  Created by Zack Brown on 27/11/2020.
//

import Foundation

public struct FootpathTileLayer: Codable, Equatable {
    
    enum CodingKeys: CodingKey {
        
        case tileType
        case slope
    }
    
    var tileType: FootpathTileType
    public var slope: Cardinal?
    
    var tilesetTile: FootpathTilesetTile? = nil
    
    init(tileType: FootpathTileType, slope: Cardinal? = nil) {
        
        self.tileType = tileType
        self.slope = slope
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        tileType = try container.decode(FootpathTileType.self, forKey: .tileType)
        slope = try container.decode(Cardinal.self, forKey: .slope)
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(tileType, forKey: .tileType)
        try container.encode(slope, forKey: .slope)
    }
}
