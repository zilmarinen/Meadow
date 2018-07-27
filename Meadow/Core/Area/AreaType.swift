//
//  AreaType.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 23/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public enum AreaType: Int, Codable {
    
    case brick
    case concrete
    case wood
    
    static var allCases: [AreaType] {
        
        return [ .brick,
                 .concrete,
                 .wood
        ]
    }
}
