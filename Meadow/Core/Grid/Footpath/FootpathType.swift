//
//  FootpathType.swift
//  Meadow
//
//  Created by Zack Brown on 26/07/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Pasture

public enum FootpathType: Int, CaseIterable, Codable {
    
    case dirt
    case tarmac
    
    public var description: String {
        
        switch self {
            
        case .dirt: return "Dirt"
        case .tarmac: return "Tarmac"
        }
    }
    
    public var primaryColor: Color {
        
        switch self {
            
        case .dirt: return Color(red: 0.54, green: 0.40, blue: 0.16)
        case .tarmac: return Color(red: 0.63, green: 0.63, blue: 0.63)
        }
    }
    
    public var secondaryColor: Color {
        
        switch self {
            
        case .dirt: return Color(red: 0.54, green: 0.34, blue: 0.16)
        case .tarmac: return Color(red: 0.35, green: 0.35, blue: 0.35)
        }
    }
}

