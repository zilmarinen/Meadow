//
//  Season.swift
//
//  Created by Zack Brown on 16/11/2020.
//

import Foundation

public enum Season: Int, CaseIterable, Codable {
    
    case spring
    case summer
    case autumn
    case winter
    
    public var description: String {
        
        switch self {
        
        case .spring: return "Spring"
        case .summer: return "Summer"
        case .autumn: return "Autumn"
        case .winter: return "Winter"
        }
    }
    
    public var abbreviation: String {
        
        switch self {
        
        case .spring: return "Sp"
        case .summer: return "Su"
        case .autumn: return "Au"
        case .winter: return "Wi"
        }
    }
}
