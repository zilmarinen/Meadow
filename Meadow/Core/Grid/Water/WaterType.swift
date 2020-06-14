//
//  WaterType.swift
//  Meadow
//
//  Created by Zack Brown on 07/06/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Pasture

public enum WaterType: Int, CaseIterable, Codable {
    
    case saltWater
    
    public var description: String {
        
        switch self {
            
        case .saltWater: return "Salt Water"
        }
    }
    
    public var primaryColor: Color {
        
        switch self {
            
        case .saltWater: return Color(red: 0.64, green: 0.8, blue: 0.91, alpha: 0.7)
        }
    }
    
    public var secondaryColor: Color {
        
        switch self {
            
        case .saltWater: return Color(red: 0.71, green: 0.87, blue: 0.98, alpha: 0.7)
        }
    }
}
