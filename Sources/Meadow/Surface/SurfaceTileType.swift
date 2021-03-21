//
//  SurfaceTileType.swift
//
//  Created by Zack Brown on 12/11/2020.
//

import Foundation

public enum SurfaceTileType: Int, CaseIterable, Codable {
    
    case dirt
    case grass
    case sand
    case undergrowth
    case water
    
    public var movementCost: Int {
        
        switch self {
        
        case .dirt: return 1
        case .grass: return 1
        case .sand: return 1
        case .undergrowth: return 1
        case .water: return 1
        }
    }
}
