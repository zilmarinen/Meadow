//
//  TerrainType.swift
//  Meadow
//
//  Created by Zack Brown on 20/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public enum TerrainType: Int, Codable {
    
    case bedrock
    case grass
    case sand
    
    public static var allCases: [TerrainType] {
        
        return [ .bedrock,
                 .grass,
                 .sand
        ]
    }
    
    public var name: String {
        
        switch self {
            
        case .bedrock: return "Bedrock"
        case .grass: return "Grass"
        case .sand: return "Sand"
        }
    }
}

extension TerrainType {
    
    public var colorPalette: ColorPalette? {
        
        return ArtDirector.shared?.palette(named: name)
    }
}
