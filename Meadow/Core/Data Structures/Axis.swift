//
//  Axis.swift
//  Meadow
//
//  Created by Zack Brown on 20/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation

public struct Axis {
    
    public static func X(x: MDWFloat) -> Int {
        
        return Int(round(x))
    }
    
    public static func Y(y: Int) -> MDWFloat {
        
        return MDWFloat(y) * unitY
    }
    
    public static func Y(y: MDWFloat) -> Int {
        
        return Int(y / unitY)
    }
    
    public static func Z(z: MDWFloat) -> Int {
        
        return Int(round(z))
    }
}

extension Axis {
    
    public static var unitXZ: MDWFloat { return 1.0 }
    public static var halfUnitXZ: MDWFloat { return unitXZ / 2.0 }
    
    public static var unitY: MDWFloat { return (1 / 4) }
}
