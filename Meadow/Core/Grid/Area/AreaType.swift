//
//  AreaType.swift
//  Meadow
//
//  Created by Zack Brown on 16/09/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Pasture

public enum AreaType: Int, CaseIterable, Codable {
    
    case brick
    
    public var description: String {
        
        switch self {
            
        case .brick: return "Brick"
        }
    }
}
