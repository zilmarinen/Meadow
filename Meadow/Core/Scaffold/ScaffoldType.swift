//
//  ScaffoldType.swift
//  Meadow
//
//  Created by Zack Brown on 23/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public enum ScaffoldType: Int, Codable {
    
    case concrete
    case wood
    case steel
    
    public static var allCases: [ScaffoldType] {
        
        return [ .concrete,
                 .wood,
                 .steel
        ]
    }
    
    public var name: String {
        
        switch self {
            
        case .concrete: return "Concrete"
        case .wood: return "Wood"
        case .steel: return "Steel"
        }
    }
}
