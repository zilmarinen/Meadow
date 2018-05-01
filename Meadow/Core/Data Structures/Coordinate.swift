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

extension Coordinate: Hashable {
    
    public static func == (lhs: Coordinate, rhs: Coordinate) -> Bool {
        
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
    }
    
    public var hashValue: Int {
        
        return x ^ y ^ z
    }
}

extension Coordinate {
    
    static func +(lhs: Coordinate, rhs: Coordinate) -> Coordinate {
        
        return Coordinate(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }
    
    static func -(lhs: Coordinate, rhs: Coordinate) -> Coordinate {
        
        return Coordinate(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
    }
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

extension Coordinate {
    
    enum Adjacency {
        
        case adjacent
        case diagonal
        case equal
        case detached
    }
    
    func adjacency(to coordinate: Coordinate) -> Adjacency {
        
        if coordinate.x == x && coordinate.z == z {
         
            return .equal
        }
        
        let adjacentX = (coordinate.x == (x - 1) || coordinate.x == (x + 1));
        let adjacentZ = (coordinate.z == (z - 1) || coordinate.z == (z + 1));
        
        if(adjacentX && coordinate.z == z) || (adjacentZ && coordinate.x == x) {
            
            return .adjacent;
        }
        else if adjacentX && adjacentZ {
            
            return .diagonal;
        }
        
        return .detached
    }
}
