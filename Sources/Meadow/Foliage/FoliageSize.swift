//
//  FoliageSize.swift
//  
//  Created by Zack Brown on 15/03/2021.
//

import Foundation

public enum FoliageSize: Int, CaseIterable, Codable, Equatable {
    
    case small
    case medium
    case large
    
    public var description: String {
        
        switch self {
        
        case .small: return "Small"
        case .medium: return "Medium"
        case .large: return "Large"
        }
    }
}

