//
//  ScaffoldType.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 23/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public enum ScaffoldType: Int, Codable {
    
    case concrete
    case wood
    case steel
    
    static var allCases: [ScaffoldType] {
        
        return [ .concrete,
                 .wood,
                 .steel
        ]
    }
}
