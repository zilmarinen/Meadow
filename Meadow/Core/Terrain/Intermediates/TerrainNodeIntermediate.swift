//
//  TerrainNodeIntermediate.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 20/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public class TerrainNodeIntermediate: GridNodeIntermediate {
    
    let children: [TerrainLayerIntermediate]
    
    enum CodingKeys: CodingKey {
        
        case children
    }
    
    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        children = try container.decode([TerrainLayerIntermediate].self, forKey: .children)
        
        try super.init(from: decoder)
    }
}
