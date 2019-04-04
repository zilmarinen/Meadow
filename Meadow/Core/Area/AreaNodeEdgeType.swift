//
//  AreaNodeEdgeType.swift
//  Meadow
//
//  Created by Zack Brown on 17/03/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

public enum AreaNodeEdgeType: Codable, Equatable {
    
    case door(AreaNodeEdgeDoor)
    case wall
    case window(AreaNodeEdgeWindow)
    
    public static var allCases: [CodingKeys] {
        
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
    
    public enum CodingKeys: Int, CodingKey {
        
        case door
        case wall
        case window
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            
            let door =  try container.decode(AreaNodeEdgeDoor.self, forKey: .door)
            
            self = .door(door)
            
        } catch {
            
            do {
                
                let window =  try container.decode(AreaNodeEdgeWindow.self, forKey: .door)
                
                self = .window(window)
                
            }
            catch {
            
                self = .wall
            }
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
            
        case .door(let door):
            
            try container.encode(door, forKey: .door)
            
        case .window(let window):
            
            try container.encode(window, forKey: .window)
            
        default: break
        }
    }
}
