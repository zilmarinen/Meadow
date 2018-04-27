//
//  Coordinate.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import  SceneKit

public struct Coordinate {
    
    let x: Int
    let y: Int
    let z: Int
}

extension Coordinate {
    
    static var Zero: Coordinate { return Coordinate(x: 0, y: 0, z: 0) }
    static var One: Coordinate { return Coordinate(x: 1, y: 1, z: 1) }
    static var Up: Coordinate { return Coordinate(x: 0, y: 1, z: 0) }
    static var Down: Coordinate { return Coordinate(x: 0, y: -1, z: 0) }
    static var Left: Coordinate { return Coordinate(x: -1, y: 0, z: 0) }
    static var Right: Coordinate { return Coordinate(x: 1, y: 0, z: 0) }
    static var Forward: Coordinate { return Coordinate(x: 0, y: 0, z: 1) }
    static var Backward: Coordinate { return Coordinate(x: 0, y: 0, z: -1) }
}
