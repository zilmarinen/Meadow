//
//  MovementCost.swift
//
//  Created by Zack Brown on 14/12/2020.
//

enum MovementCost: Int, CaseIterable, Codable {
    
    case `default`
    case slow
    
    var description: String {
        
        switch self {
        
        case .default: return "Default"
        case .slow: return "Slow"
        }
    }
}
