//
//  Season.swift
//
//  Created by Zack Brown on 16/11/2020.
//

import Foundation

public enum Season: Int, CaseIterable, Codable, Identifiable {
    
    case spring
    case summer
    case autumn
    case winter
    
    public var id: String {
        
        switch self {
        
        case .spring: return "spring"
        case .summer: return "summer"
        case .autumn: return "autumn"
        case .winter: return "winter"
        }
    }
}
