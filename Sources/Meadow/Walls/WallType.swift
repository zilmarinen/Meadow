//
//  WallType.swift
//
//  Created by Zack Brown on 09/08/2021.
//

import Foundation

public enum WallType: CaseIterable, Codable, Hashable, Identifiable {
    
    public static var allCases: [WallType] { [.door,
                                              .wall,
                                              .window] }
    
    case corner
    case door
    case edge(left: Bool)
    case wall
    case window
    
    public var id: String {
        
        switch self {
        
        case .corner: return "corner"
        case .door: return "door"
        case .edge: return "edge"
        case .wall: return "wall"
        case .window: return "window"
        }
    }
}

