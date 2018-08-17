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
        
        return MDWFloat(y) * unitY
    }
    
    public static func Y(y: MDWFloat) -> Int {
        
        return Int(y / unitY)
    }
}

extension Axis {
    
    static var unitXZ: MDWFloat { return 1.0 }
    static var halfUnitXZ: MDWFloat { return unitXZ / 2.0 }
    
    static var unitY: MDWFloat { return 0.25 }
}
