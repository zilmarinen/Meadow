//
//  TerrainTileWeighting.swift
//
//  Created by Zack Brown on 16/11/2020.
//

import Foundation

enum TerrainTileWeighting: Int, CaseIterable, Codable {
    
    case common
    case rare
    case epic
    case legendary
    
    var description: String {
        
        switch self {
        
        case .common: return "Common"
        case .rare: return "Rare"
        case .epic: return "Epic"
        case .legendary: return "Legendary"
        }
    }
}
