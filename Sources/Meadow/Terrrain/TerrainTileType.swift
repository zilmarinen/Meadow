//
//  TerrainTileType.swift
//
//  Created by Zack Brown on 12/11/2020.
//

import Foundation

public enum TerrainTileType: Int, CaseIterable, Codable {
    
    case dirt = 2
    case grass = 3
    case sand = 1
    case undergrowth = 4
    case water = 0
    
    var next: TerrainTileType {
        
        switch self {
        
        case .dirt: return .grass
        case .grass: return .undergrowth
        case .sand: return .dirt
        case .undergrowth: return .undergrowth
        case .water: return .sand
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
    
    func blends(with tileType: TerrainTileType) -> Bool {
        
        switch self {
        
        case .dirt: return [.sand, .dirt, .grass].contains(tileType)
        case .grass: return [.dirt, .grass, .undergrowth].contains(tileType)
        case .sand: return [.water, .sand, .dirt].contains(tileType)
        case .undergrowth: return [.grass, .undergrowth].contains(tileType)
        case .water: return [.water, .sand].contains(tileType)
        }
    }
}
