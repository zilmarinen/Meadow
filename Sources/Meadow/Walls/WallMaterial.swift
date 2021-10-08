//
//  WallMaterial.swift
//
//  Created by Zack Brown on 12/08/2021.
//

import Foundation
import SwiftUI

public enum WallMaterial: Int, CaseIterable, Codable, Hashable, Identifiable {
    
    case concrete
    case picket
    
    public var id: String {
        
        switch self {
        
        case .concrete: return "concrete"
        case .picket: return "picket"
        }
    }
    
    func propIdentifier(tileType: WallType, pattern: Cardinal, external: Bool) -> String {
        
        switch self {
        
        case .concrete:
            
            let prop = id + "_" + tileType.id
            
            switch tileType {
            
            case .corner: return prop
            case .edge(let lhs):
                
                return prop + (external ? "_external" + (lhs ? "_left" : "_right") : "_internal")
                
            default:
                
                return prop + (external ? "_external" : "_internal")
            }
            
        case .picket:
            
            let prop = id + "_" + tileType.id
            
            switch tileType {
                
            case .corner: return prop + "_\(pattern.count)"
            default: return prop
            }
        }
    }
}
