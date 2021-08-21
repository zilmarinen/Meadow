//
//  BridgeTileType.swift
//
//  Created by Zack Brown on 15/08/2021.
//

import Foundation
import SwiftUI

public enum BridgeTileType: Codable, Equatable, Identifiable {
    
    case corner(Bool)
    case edge(Bool)
    case path
    case wall
    
    public var id: String {
        
        switch self {
            
        case .corner: return "corner"
        case .edge: return "edge"
        case .path: return "path"
        case .wall: return "wall"
        }
    }
}
