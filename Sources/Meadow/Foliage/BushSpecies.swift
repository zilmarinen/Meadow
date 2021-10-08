//
//  BushSpecies.swift
//
//  Created by Zack Brown on 03/10/2021.
//

public enum BushSpecies: Int, CaseIterable, Codable, Hashable, Identifiable {
    
    case honeysuckle
    
    public var id: String {
        
        switch self {
        
        case .honeysuckle: return "honeysuckle"
        }
    }
}
