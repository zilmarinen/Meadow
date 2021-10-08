//
//  RockType.swift
//
//  Created by Zack Brown on 03/10/2021.
//

public enum RockType: Int, CaseIterable, Codable, Hashable, Identifiable {
    
    case causeway
    
    public var id: String {
        
        switch self {
        
        case .causeway: return "causeway"
        }
    }
}
