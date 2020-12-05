//
//  FootpathTileType.swift
//
//  Created by Zack Brown on 27/11/2020.
//

import Foundation

public enum FootpathTileType: Int, CaseIterable, Codable, Equatable {
    
    case cobble
    case dirt
    case gravel
    case stone
    case wood
    
    public var description: String {
        
        switch self {
        
        case .cobble: return "Cobble"
        case .dirt: return "Dirt"
        case .gravel: return "Gravel"
        case .stone: return "Stone"
        case .wood: return "Wood"
        }
    }
    
    var color: Color {
        
        switch self {
        
        case .dirt: return Color(red: 0.92, green: 0.78, blue: 0.53, alpha: 1.0)
        case .gravel: return Color(red: 0.8, green: 0.78, blue: 0.53, alpha: 1.0)
        case .stone: return Color(red: 0.95, green: 0.57, blue: 0.2, alpha: 1.0)
        case .unknown: return Color(red: 0.8, green: 0.89, blue: 0.45, alpha: 1.0)
        case .wood: return Color(red: 0.54, green: 0.8, blue: 0.8, alpha: 1.0)
        }
    }
}
