//
//  TerrainType.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 20/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public enum TerrainType: Int, Codable {
    
    case bedrock
    case grass
    case sand
    
    static var allCases: [TerrainType] {
        
        return [ .bedrock,
                 .grass,
                 .sand
        ]
    }
}

extension TerrainType {
    
    var meshProvider: TerrainLayerMeshProvider {
        
        return TerrainLayerMeshProvider()
    }
    
    var colorPalette: ColorPalette? {
        
        switch self {
            
        case .bedrock:
            
            return ColorPalettes.shared.palette(named: "bedrock")
            
        default: return nil
        }
    }
}
