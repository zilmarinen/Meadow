//
//  FootpathType.swift
//  Meadow
//
//  Created by Zack Brown on 23/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public enum FootpathType: Int, Codable {
    
    case asphalt
    case dirt
    
    public static var allCases: [FootpathType] {
        
        return [ .asphalt,
                 .dirt,
        ]
    }
    
    public var name: String {
        
        switch self {
            
        case .asphalt: return "Asphalt"
        case .dirt: return "Dirt"
        }
    }
}

extension FootpathType {
    
    public var colorPalette: ColorPalette? {
        
        return ColorPalettes.shared?.palette(named: name)
    }
}
