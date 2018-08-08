//
//  FootpathNodeIntermediate.swift
//  Meadow
//
//  Created by Zack Brown on 27/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public class FootpathNodeIntermediate: GridNodeIntermediate {
    
    let slope: FootpathNode.Slope?
    
    let footpathType: Int
    
    enum CodingKeys: CodingKey {
        
        case slope
        case footpathType
    }
    
    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        slope = try container.decodeIfPresent(FootpathNode.Slope.self, forKey: .slope)
        
        footpathType = try container.decode(Int.self, forKey: .footpathType)
        
        try super.init(from: decoder)
    }
}
