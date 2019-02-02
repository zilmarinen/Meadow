//
//  GridNodeIntermediate.swift
//  Meadow
//
//  Created by Zack Brown on 20/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public class GridNodeIntermediate: Decodable {
    
    let name: String?
    
    let volume: Volume
    
    private enum CodingKeys: CodingKey {
        
        case name
        case volume
    }
    
    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decodeIfPresent(String.self, forKey: .name)
        
        volume = try container.decode(Volume.self, forKey: .volume)
    }
}
