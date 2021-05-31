//
//  StairType.swift
//
//  Created by Zack Brown on 19/05/2021.
//

import Foundation

public enum StairType: Int, CaseIterable, Codable, Equatable {
    
    case stone
    
    var color: Color {
        
        switch self {
        
        case .stone: return Color(red: 0.07, green: 0.07, blue: 0.07)
        }
    }
}
