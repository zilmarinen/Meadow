//
//  WallTileType.swift
//
//  Created by Zack Brown on 09/08/2021.
//

import Foundation

public enum WallTileType: CaseIterable, Codable, Equatable {
    
    public static var allCases: [WallTileType] { [.door,
                                                  .wall,
                                                  .window] }
    
    case corner
    case door
    case edge(left: Bool)
    case wall
    case window
    
    var identifier: String {
        
        switch self {
        
        case .corner: return "corner"
        case .door: return "door"
        case .edge: return "edge"
        case .wall: return "wall"
        case .window: return "window"
        }
    }
}

