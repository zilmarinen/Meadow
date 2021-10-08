//
//  PortalType.swift
//
//  Created by Zack Brown on 27/03/2021.
//

import Foundation

public enum PortalType: Int, CaseIterable, Codable, Identifiable {
    
    case portal
    case spawn
    
    public var id: String {
        
        switch self {
            
        case .portal: return "portal"
        case .spawn: return "spawn"
        }
    }
}
