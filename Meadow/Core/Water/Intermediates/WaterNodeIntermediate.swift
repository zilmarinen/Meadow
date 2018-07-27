//
//  WaterNodeIntermediate.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 25/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public class WaterNodeIntermediate: GridNodeIntermediate {
    
    let waterLevel: Int
    
    let waterType: String
    
    enum CodingKeys: CodingKey {
        
        case waterLevel
        case waterType
    }
    
    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        waterLevel = try container.decode(Int.self, forKey: .waterLevel)
        
        waterType = try container.decode(String.self, forKey: .waterType)
        
        let superDecoder = try container.superDecoder()
        
        try super.init(from: superDecoder)
    }
}
