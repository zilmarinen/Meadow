//
//  WaterType.swift
//  Meadow
//
//  Created by Zack Brown on 23/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public enum WaterType: Int, Codable {
    
    case water
    
    public static var allCases: [WaterType] {
        
        return [ .water
        ]
    }
    
    public var name: String {
        
        switch self {
            
        case .water: return "Water"
        }
    }
}

extension WaterType {
    
    public var colorPalette: ColorPalette? {
        
        return ColorPalettes.shared?.palette(named: name)
    }
}
