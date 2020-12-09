//
//  FoliageTileType.swift
//
//  Created by Zack Brown on 07/12/2020.
//

import Foundation

public enum FoliageTileType: Int, CaseIterable, Codable, Equatable {
    
    case bush
    case tree
    
    public var description: String {
        
        switch self {
        
        case .bush: return "Bush"
        case .tree: return "Tree"
        }
    }
    
    var color: Color {
        
        switch self {
        
        case .bush: return Color(red: 0.92, green: 0.78, blue: 0.53, alpha: 1.0)
        case .tree: return Color(red: 0.8, green: 0.78, blue: 0.53, alpha: 1.0)
        }
    }
}
