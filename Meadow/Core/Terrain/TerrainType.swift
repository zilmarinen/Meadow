//
//  TerrainType.swift
//  Meadow
//
//  Created by Zack Brown on 20/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public enum TerrainType: Int, Codable {
    
    case bedrock
    case grass1
    case grass2
    case grass3
    case sand
    
    public static var allCases: [TerrainType] {
        
        return [ .bedrock,
                 .grass1,
                 .grass2,
                 .grass3,
                 .sand
        ]
    }
    
    public var name: String {
        
        switch self {
            
        case .bedrock: return "Bedrock"
        case .grass1: return "Grass 1"
        case .grass2: return "Grass 2"
        case .grass3: return "Grass 3"
        case .sand: return "Sand"
        }
    }
}

extension TerrainType {
    
    public var colorPalette: ColorPalette? {
        
        return ArtDirector.shared?.palette(named: name)
    }
}
