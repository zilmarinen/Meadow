//
//  Season.swift
//
//  Created by Zack Brown on 16/11/2020.
//

import Foundation

public enum Season: Int, CaseIterable, Codable {
    
    case spring
    case summer
    case autumn
    case winter
    
    var description: String {
        
        switch self {
        
        case .spring: return "Spring"
        case .summer: return "Summer"
        case .autumn: return "Autumn"
        case .winter: return "Winter"
        }
    }
    
    var abbreviation: String {
        
        switch self {
        
        case .spring: return "Sp"
        case .summer: return "Su"
        case .autumn: return "Au"
        case .winter: return "Wi"
        }
    }
    
    var tileset: TerrainTileset? {
        
        return try? TerrainTileset(season: self)
    }
}
