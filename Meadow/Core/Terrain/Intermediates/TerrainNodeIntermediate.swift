//
//  TerrainNodeIntermediate.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 20/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public class TerrainNodeIntermediate: GridNodeIntermediate {
    
    let layers: [TerrainLayerIntermediate]
    
    enum CodingKeys: CodingKey {
        
        case layers
    }
    
    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        layers = try container.decode([TerrainLayerIntermediate].self, forKey: .layers)
        
        let superDecoder = try container.superDecoder()
        
        try super.init(from: superDecoder)
    }
}
