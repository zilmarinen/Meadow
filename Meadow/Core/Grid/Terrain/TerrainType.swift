//
//  TerrainType.swift
//  Meadow
//
//  Created by Zack Brown on 03/06/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Pasture

public enum TerrainType: Int, CaseIterable, Codable {
    
    case bedrock
    case dirt
    case grass
    case gravel
    case sand
    case sandstone
    case stone
    
    public var description: String {
        
        switch self {
            
        case .bedrock: return "Bedrock"
        case .dirt: return "Dirt"
        case .grass: return "Grass"
        case .gravel: return "Gravel"
        case .sand: return "Sand"
        case .sandstone: return "Sandstone"
        case .stone: return "Stone"
        }
    }
    
    public var primaryColor: Color {
        
        switch self {
            
        case .bedrock: return Color(red: 0.35, green: 0.35, blue: 0.35)
            
        case .grass: return Color(red: 0.51, green: 0.92, blue: 0.49)
            
        default: return .black
        }
    }
        
    public var secondaryColor: Color {
        
        switch self {
            
        case .bedrock: return Color(red: 0.75, green: 0.75, blue: 0.75)
            
        case .grass: return Color(red: 0.72, green: 0.53, blue: 0.41)
            
        default: return .black
        }
    }
}
