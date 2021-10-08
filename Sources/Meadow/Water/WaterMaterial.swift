//
//  WaterMaterial.swift
//
//  Created by Zack Brown on 21/03/2021.
//

import Foundation

public enum WaterMaterial: Int, CaseIterable, Codable, Equatable, Identifiable {
    
    case water
    
    public var id: String {
        
        switch self {
            
        case .water: return "water"
        }
    }
}
