//
//  BridgeMaterial.swift
//
//  Created by Zack Brown on 15/08/2021.
//

import Foundation
import SwiftUI

public enum BridgeMaterial: Int, CaseIterable, Codable, Hashable, Identifiable {
    
    case stone
    case wood
    
    public var id: String {
        
        switch self {
            
        case .stone: return "stone"
        case .wood: return "wood"
        }
    }
    
    func propIdentifier(tileType: BridgeTileType, pattern: Cardinal) -> String {
        
        let prop = id + "_bridge_" + tileType.id
        
        switch tileType {
            
        case .corner(let lhs):
            
            if pattern.count == 2 {
                
                return prop + "_dual"
            }
            
            return prop + (lhs ? "_left" : "_right")
            
        case .edge(let lhs): return prop + (lhs ? "_left" : "_right")
        default: return prop
        }
    }
}
