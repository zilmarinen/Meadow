//
//  Rarity.swift
//
//  Created by Zack Brown on 16/11/2020.
//

import Foundation

public enum Rarity: Int, CaseIterable, Codable {
    
    case common
    case rare
    case epic
    case legendary
    
    public var description: String {
        
        switch self {
        
        case .common: return "Common"
        case .rare: return "Rare"
        case .epic: return "Epic"
        case .legendary: return "Legendary"
        }
    }
}
