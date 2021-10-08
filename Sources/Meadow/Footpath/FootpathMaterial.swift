//
//  FootpathMaterial.swift
//
//  Created by Zack Brown on 16/03/2021.
//

public enum FootpathMaterial: Int, CaseIterable, Codable, Equatable, Identifiable {
    
    case cobble
    case dirt
    case gravel
    case stone
    case wood
    
    public var id: String {
        
        switch self {
        
        case .cobble: return "cobble"
        case .dirt: return "dirt"
        case .gravel: return "gravel"
        case .stone: return "stone"
        case .wood: return "wood"
        }
    }
    
    public var movementCost: Int {
        
        switch self {
        
        case .cobble: return 1
        case .dirt: return 1
        case .gravel: return 1
        case .stone: return 1
        case .wood: return 1
        }
    }
}
