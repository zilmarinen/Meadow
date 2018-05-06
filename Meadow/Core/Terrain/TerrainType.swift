//
//  TerrainType.swift
//  Meadow
//
//  Created by Zack Brown on 05/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public struct TerrainType {
    
    let name: String
}

extension TerrainType: Hashable {
    
    public static func == (lhs: TerrainType, rhs: TerrainType) -> Bool {
        
        return lhs.name == rhs.name
    }
    
    public var hashValue: Int {
        
        return name.hashValue
    }
}
