//
//  FootpathTileType.swift
//
//  Created by Zack Brown on 16/03/2021.
//

import Foundation

public enum FootpathTileType: Int, CaseIterable, Codable, Equatable {
    
    case cobble
    case dirt
    case gravel
    case stone
    case wood
    
    public var movementCost: Int {
        
        switch self {
        
        case .cobble: return 1
        case .dirt: return 1
        case .gravel: return 1
        case .stone: return 1
        case .wood: return 1
        }
    }
}
