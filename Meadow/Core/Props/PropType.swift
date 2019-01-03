//
//  PropType.swift
//  Meadow
//
//  Created by Zack Brown on 19/11/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public enum PropType: Int, Codable {
    
    case decoration
    case structural
    case utility
    
    public static var allCases: [PropType] {
        
        return [ .decoration,
                 .structural,
                 .utility
        ]
    }
    
    public var name: String {
        
        switch self {
            
        case .decoration: return "Decoration"
        case .structural: return "Structural"
        case .utility: return "Utility"
        }
    }
}
