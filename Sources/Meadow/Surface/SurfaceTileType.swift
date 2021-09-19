//
//  SurfaceTileType.swift
//
//  Created by Zack Brown on 12/11/2020.
//

import Foundation

public enum SurfaceTileType: Int, CaseIterable, Codable, Identifiable {
    
    case dirt
    case sand
    case stone
    case wood
    
    public var id: String {
        
        switch self {
        
        case .dirt: return "dirt"
        case .sand: return "sand"
        case .stone: return "stone"
        case .wood: return "wood"
        }
    }
    
    var texture: Texture? {
        
        guard let image = MDWImage.asset(named: "surface_\(id)", in: .module) else { return nil }
    
        return Texture(key: id, image: image)
    }
    
    public var movementCost: Double {
        
        switch self {
        
        case .dirt: return 1
        case .sand: return 1
        case .stone: return 1
        case .wood: return 1
        }
    }
}
