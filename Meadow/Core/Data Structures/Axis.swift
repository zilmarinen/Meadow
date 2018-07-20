//
//  Axis.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 20/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation

public struct Axis {
    
    public static func Y(y: Int) -> MDWFloat {
        
        return MDWFloat(y) * UnitY
    }
    
    public static func Y(y: MDWFloat) -> Int {
        
        return Int(y / UnitY)
    }
}

extension Axis {
    
    static var UnitXZ: MDWFloat { return 1.0 }
    static var UnitY: MDWFloat { return 0.25 }
}
