//
//  WaterType.swift
//  Meadow
//
//  Created by Zack Brown on 23/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public enum WaterType: Int, Codable {
    
    case water
    case lava
    
    public static var allCases: [WaterType] {
        
        return [ .water,
                 .lava
        ]
    }
    
    public var name: String {
        
        switch self {
            
        case .lava: return "Lava"
        case .water: return "Water"
        }
    }
}

extension WaterType {
    
    public var colorPalette: ColorPalette? {
        
        return ArtDirector.shared?.palette(named: name)
    }
}
