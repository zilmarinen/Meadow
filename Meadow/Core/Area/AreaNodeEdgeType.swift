//
//  AreaNodeEdgeType.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 25/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public enum AreaNodeEdgeType: Int, Codable {
    
    case door
    case wall
    case window
    
    public static var allCases: [AreaNodeEdgeType] {
        
        return [ .door,
                 .wall,
                 .window
        ]
    }
    
    public var name: String {
        
        switch self {
            
        case .door: return "Door"
        case .wall: return "Wall"
        case .window: return "Window"
        }
    }
}
