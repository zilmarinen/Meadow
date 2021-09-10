//
//  SurfaceTileType.swift
//
//  Created by Zack Brown on 12/11/2020.
//

import Foundation

public enum SurfaceTileType: Int, CaseIterable, Codable {
    
    case dirt
    case sand
    case stone
    case wood
    
    public var movementCost: Double {
        
        switch self {
        
        case .dirt: return 1
        case .sand: return 1
        case .stone: return 1
        case .wood: return 1
        }
    }
}
