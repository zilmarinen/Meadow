//
//  FoliageType.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 17/09/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Pasture

public enum FoliageType: Int, CaseIterable, Codable {
    
    case fir
    
    public var description: String {
        
        switch self {
            
        case .fir: return "Fir"
        }
    }
}
