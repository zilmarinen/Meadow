//
//  BuildingType.swift  
//
//  Created by Zack Brown on 09/04/2021.
//

import Foundation

public enum BuildingArchitecture: Int, CaseIterable, Codable, Hashable, Identifiable {
    
    case bernina
    case daisen
    case elna
    case juki
    case merrow
    case necchi
    case singer
    
    public var id: String {
        
        switch self {
        
        case .bernina: return "bernina"
        case .daisen: return "daisen"
        case .elna: return "elna"
        case .juki: return "juki"
        case .merrow: return "merrow"
        case .necchi: return "necchi"
        case .singer: return "singer"
        }
    }
}
