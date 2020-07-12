//
//  Coordinate.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Pasture
import SceneKit

public struct Coordinate: Codable {
    
    public let x: Int
    public let y: Int
    public let z: Int
    
    public init(x: Int, y: Int, z: Int) {
        
        self.x = x
        self.y = y
        self.z = z
    }
    
    public init(vector: SCNVector3) {
        
        self.x = World.Axis.xz(value: Double(vector.x))
        self.y = World.Axis.y(value: Double(vector.y))
        self.z = World.Axis.xz(value: Double(vector.z))
    }
    
    public init(vector: Vector) {
        
        self.x = World.Axis.xz(value: Double(vector.x))
        self.y = World.Axis.y(value: Double(vector.y))
        self.z = World.Axis.xz(value: Double(vector.z))
    }
}

public extension Coordinate {
    
    static var zero = Coordinate(x: 0, y: 0, z: 0)
    static var left = Coordinate(x: -1, y: 0, z: 0)
    static var right = Coordinate(x: 1, y: 0, z: 0)
    static var forward = Coordinate(x: 0, y: 0, z: 1)
    static var backward = Coordinate(x: 0, y: 0, z: -1)
    static var up = Coordinate(x: 0, y: 1, z: 0)
    static var down = Coordinate(x: 0, y: -1, z: 0)
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
    
    enum Adjacency {
        
        case adjacent
        case adrift
        case diagonal
        case equal
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
        
        return .adrift
    }
}

extension Coordinate {
    
    private static var Cardinals: [Coordinate] { return [
    
        .backward,
        .right,
        .forward,
        .left
    ]}
    
    public static func cardinal(cardinal: Cardinal) -> Coordinate {
        
        return Cardinals[cardinal.rawValue]
    }
}

extension Coordinate: Equatable {
    
    public static func == (lhs: Coordinate, rhs: Coordinate) -> Bool {
        
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
    }
}

extension Coordinate: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        
        hasher.combine(x)
        hasher.combine(y)
        hasher.combine(z)
    }
}
