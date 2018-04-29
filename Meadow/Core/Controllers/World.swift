//
//  World.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public enum World {
    
    static var Ceiling: Coordinate { return Coordinate(x: 0, y: 10, z: 0) }
    static var Floor: Coordinate { return Coordinate(x: 0, y: -10, z: 0) }
    static var UnitXZ: CGFloat = 0.5
    static var UnitY: CGFloat = 0.25
}

extension World {
    
    static func Y(y: Int) -> CGFloat {
        
        return CGFloat(y) * UnitY
    }
}
