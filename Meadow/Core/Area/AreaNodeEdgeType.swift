//
//  AreaNodeEdgeType.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 25/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public enum AreaNodeEdgeType: Int, Codable {
    
    case door
    case doorWithTransom
    case doubleDoor
    case doubleDoorWithTransom
    case wall
    case windowFullWidth
    case windowHalfWidth
    
    public static var allCases: [AreaNodeEdgeType] {
        
        return [ .door,
                 .doorWithTransom,
                 .doubleDoor,
                 .doubleDoorWithTransom,
                 .wall,
                 .windowFullWidth,
                 .windowHalfWidth
        ]
    }
    
    public var name: String {
        
        switch self {
            
        case .door: return "Door"
        case .doorWithTransom: return "Door with Transom"
        case .doubleDoor: return "Double Door"
        case .doubleDoorWithTransom: return "Double Door with Transom"
        case .wall: return "Wall"
        case .windowFullWidth: return "Window Full Width"
        case .windowHalfWidth: return "Window Half Width"
        }
    }
}
