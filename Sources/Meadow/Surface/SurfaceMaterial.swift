//
//  SurfaceMaterial.swift
//
//  Created by Zack Brown on 07/09/2021.
//

import Foundation

public enum SurfaceMaterial: Int, CaseIterable, Codable, Identifiable {
    
    public static let solids: [SurfaceMaterial] = [.dirt,
                                            .sand,
                                            .stone,
                                            .undergrowth]
    
    case air
    case dirt
    case sand
    case stone
    case undergrowth
    
    public var id: String {
        
        switch self {
        
        case .air: return "air"
        case .dirt: return "dirt"
        case .sand: return "sand"
        case .stone: return "stone"
        case .undergrowth: return "undergrowth"
        }
    }

    public var movementCost: Double {
        
        switch self {
        
        case .air: return 0
        case .dirt: return 1
        case .sand: return 1
        case .stone: return 1
        case .undergrowth: return 1
        }
    }
}
