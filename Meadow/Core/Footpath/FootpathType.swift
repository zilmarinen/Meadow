//
//  FootpathType.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 23/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public enum FootpathType: Int, Codable {
    
    case asphalt
    case dirt
    case tarmac
    
    public static var allCases: [FootpathType] {
        
        return [ .asphalt,
                 .dirt,
                 .tarmac
        ]
    }
    
    public var name: String {
        
        switch self {
            
        case .asphalt: return "Asphalt"
        case .dirt: return "Dirt"
        case .tarmac: return "Tarmac"
        }
    }
}

extension FootpathType {
    
    public var colorPalette: ColorPalette? {
        
        return ColorPalettes.shared?.palette(named: name)
    }
}
