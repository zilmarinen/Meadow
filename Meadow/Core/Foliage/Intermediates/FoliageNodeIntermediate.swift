//
//  FoliageNodeIntermediate.swift
//  Meadow
//
//  Created by Zack Brown on 27/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public class FoliageNodeIntermediate: GridNodeIntermediate {
    
    let foliageType: FoliageType
    
    enum CodingKeys: CodingKey {
        
        case foliageType
    }
    
    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        foliageType = try container.decode(FoliageType.self, forKey: .foliageType)
        
        try super.init(from: decoder)
    }
}
