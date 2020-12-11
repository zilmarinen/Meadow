//
//  AreaTileType.swift
//
//  Created by Zack Brown on 08/12/2020.
//

import Foundation

public enum AreaTileType: Int, CaseIterable, Codable, Equatable {
    
    case dirt = 2
    case grass = 3
    case sand = 1
    case undergrowth = 4
    case water = 0
    
    public var description: String {
        
        switch self {
        
        case .dirt: return "Dirt"
        case .grass: return "Grass"
        case .sand: return "Sand"
        case .undergrowth: return "Undergrowth"
        case .water: return "Water"
        }
    }
    
    public var movementCost: Int {
        
        switch self {
        
        case .dirt: return 1
        case .grass: return 1
        case .sand: return 1
        case .undergrowth: return 1
        case .water: return 1
        }
    }
    
    var color: Color {
        
        switch self {
        
        case .dirt: return Color(red: 0.92, green: 0.78, blue: 0.53, alpha: 1.0)
        case .grass: return Color(red: 0.8, green: 0.78, blue: 0.53, alpha: 1.0)
        case .sand: return Color(red: 0.95, green: 0.57, blue: 0.2, alpha: 1.0)
        case .undergrowth: return Color(red: 0.8, green: 0.89, blue: 0.45, alpha: 1.0)
        case .water: return Color(red: 0.54, green: 0.8, blue: 0.8, alpha: 1.0)
        }
    }
}
