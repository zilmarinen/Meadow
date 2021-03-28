//
//  FootpathTilesetTile.swift
//
//  Created by Zack Brown on 25/03/2021.
//

import Foundation

public class FootpathTilesetTile: TilesetTile {
    
    private enum CodingKeys: CodingKey {
        
        case tileType
    }
    
    public let tileType: FootpathTileType
    
    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        tileType = try container.decode(FootpathTileType.self, forKey: .tileType)
        
        try super.init(from: decoder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(tileType, forKey: .tileType)
    }
}
