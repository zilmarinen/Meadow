//
//  SurfaceMaterial.swift
//
//  Created by Zack Brown on 07/09/2021.
//

import Foundation

public enum SurfaceMaterial: Int, CaseIterable, Codable {
    
    case grass
    case undergrowth
    case water
    
    public var movementCost: Double {
        
        switch self {
        
        case .grass: return 1
        case .undergrowth: return 1
        case .water: return 1
        }
    }
}
