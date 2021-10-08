//
//  SurfaceOverlay.swift
//
//  Created by Zack Brown on 19/03/2021.
//

public enum SurfaceOverlay: Int, CaseIterable, Codable, Identifiable {
    
    case grass
    case undergrowth
    case water
    
    public var id: String {
        
        switch self {
        
        case .grass: return "grass"
        case .undergrowth: return "undergrowth"
        case .water: return "water"
        }
    }
    
    public var movementCost: Double {
        
        switch self {
        
        case .grass: return 1
        case .undergrowth: return 1
        case .water: return 1
        }
    }
}
