//
//  AreaNodeIntermediate.swift
//  Meadow
//
//  Created by Zack Brown on 20/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public class AreaNodeIntermediate: GridNodeIntermediate {

    let children: [AreaNodeEdgeIntermediate]
    
    enum CodingKeys: CodingKey {
        
        case children
    }
    
    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        children = try container.decode([AreaNodeEdgeIntermediate].self, forKey: .children)
        
        try super.init(from: decoder)
    }
}
