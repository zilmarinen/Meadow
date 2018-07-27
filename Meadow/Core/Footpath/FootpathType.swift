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
    
    static var allCases: [FootpathType] {
        
        return [ .asphalt,
                 .dirt,
                 .tarmac
        ]
    }
}
