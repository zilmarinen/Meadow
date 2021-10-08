//
//  TreeSpecies.swift
//
//  Created by Zack Brown on 03/10/2021.
//

public enum TreeSpecies: Int, CaseIterable, Codable, Hashable, Identifiable {
    
    case palm
    case pine
    case spruce
    
    public var id: String {
        
        switch self {
            
        case .palm: return "palm"
        case .pine: return "pine"
        case .spruce: return "spruce"
        }
    }
}
