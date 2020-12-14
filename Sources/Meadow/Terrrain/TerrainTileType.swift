//
//  TerrainTileType.swift
//
//  Created by Zack Brown on 12/11/2020.
//

import Foundation

public enum TerrainTileType: Int, CaseIterable, Codable, Equatable {
    
    case dirt
    case grass
    case sand
    case undergrowth
    case water
    
    public var description: String {
        
        switch self {
        
        case .dirt: return "Dirt"
        case .grass: return "Grass"
        case .sand: return "Sand"
        case .undergrowth: return "Undergrowth"
        case .water: return "Water"
        }
    }
    
    public var abbreviation: String {
        
        switch self {
        
        case .dirt: return "D"
        case .grass: return "G"
        case .sand: return "S"
        case .undergrowth: return "U"
        case .water: return "W"
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
    
    public var next: TerrainTileType {
        
        switch self {
        
        case .dirt: return .grass
        case .grass: return .undergrowth
        case .sand: return .dirt
        case .undergrowth: return .undergrowth
        case .water: return .sand
        }
    }
    
    public var color: Color {
        
        switch self {
        
        case .dirt: return Color(red: 0.92, green: 0.78, blue: 0.53, alpha: 1.0)
        case .grass: return Color(red: 0.8, green: 0.78, blue: 0.53, alpha: 1.0)
        case .sand: return Color(red: 0.95, green: 0.57, blue: 0.2, alpha: 1.0)
        case .undergrowth: return Color(red: 0.8, green: 0.89, blue: 0.45, alpha: 1.0)
        case .water: return Color(red: 0.54, green: 0.8, blue: 0.8, alpha: 1.0)
        }
    }
    
    public func blends(with tileType: TerrainTileType) -> Bool {
        
        switch self {
        
        case .dirt: return [.sand, .dirt, .grass].contains(tileType)
        case .grass: return [.dirt, .grass, .undergrowth].contains(tileType)
        case .sand: return [.water, .sand, .dirt].contains(tileType)
        case .undergrowth: return [.grass, .undergrowth].contains(tileType)
        case .water: return [.water, .sand].contains(tileType)
        }
    }
}
