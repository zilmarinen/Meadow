//
//  TunnelType.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 23/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public enum TunnelType: Int, Codable {
    
    case concrete
    case glass
    
    static var allCases: [TunnelType] {
        
        return [ .concrete,
                 .glass
        ]
    }
}
