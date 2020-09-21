//
//  WaterType.swift
//  Meadow
//
//  Created by Zack Brown on 07/06/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Pasture

public enum WaterType: Int, CaseIterable, Codable {
    
    case lava
    case saltWater
    
    public var description: String {
        
        switch self {
            
        case .lava: return "Lava"
        case .saltWater: return "Salt Water"
        }
    }
    
    public var primaryColor: Color {
        
        switch self {
            
        case .lava: return Color(red: 0.75, green: 0.21, blue: 0.19, alpha: 0.91)
        case .saltWater: return Color(red: 0.64, green: 0.8, blue: 0.91, alpha: 0.91)
        }
    }
    
    public var secondaryColor: Color {
        
        switch self {
            
        case .lava: return Color(red: 0.98, green: 0.37, blue: 0.34, alpha: 0.91)
        case .saltWater: return Color(red: 0.71, green: 0.87, blue: 0.98, alpha: 0.84)
        }
    }
}
