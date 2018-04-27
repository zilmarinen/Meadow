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
    static var UnitY = 0.25
}
