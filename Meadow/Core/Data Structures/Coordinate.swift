//
//  Coordinate.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

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
    
    public init(x: MDWFloat, y: MDWFloat, z: MDWFloat) {
        
        self.x = Axis.X(x: x)
        self.y = Axis.Y(y: y)
        self.z = Axis.Z(z: z)
    }
    
    public init(vector: SCNVector3) {
        
        self.x = Axis.X(x: vector.x)
        self.y = Axis.Y(y: vector.y)
        self.z = Axis.Z(z: vector.z)
    }
}

extension Coordinate: Hashable {
    
    public static func == (lhs: Coordinate, rhs: Coordinate) -> Bool {
        
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
    }
    
    public func hash(into hasher: inout Hasher) {
        
        hasher.combine(x)
        hasher.combine(y)
        hasher.combine(z)
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

public extension Coordinate {
    
    static var zero: Coordinate { return Coordinate(x: 0, y: 0, z: 0) }
    static var one: Coordinate { return Coordinate(x: 1, y: 1, z: 1) }
    static var up: Coordinate { return Coordinate(x: 0, y: 1, z: 0) }
    static var down: Coordinate { return Coordinate(x: 0, y: -1, z: 0) }
    static var left: Coordinate { return Coordinate(x: 1, y: 0, z: 0) }
    static var right: Coordinate { return Coordinate(x: -1, y: 0, z: 0) }
    static var forward: Coordinate { return Coordinate(x: 0, y: 0, z: 1) }
    static var backward: Coordinate { return Coordinate(x: 0, y: 0, z: -1) }
    
    static var GridEdgeExtents: [Coordinate] { return [
        
        Coordinate.forward,
        Coordinate.right,
        Coordinate.backward,
        Coordinate.left
    ]}
    
    static var GridCornerExtents: [Coordinate] { return [
        
        Coordinate.forward + Coordinate.left,
        Coordinate.forward + Coordinate.right,
        Coordinate.backward + Coordinate.right,
        Coordinate.backward + Coordinate.left
    ]}
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

extension Coordinate {
    
    static func rotate(coordinate: Coordinate, rotation: GridEdge) -> Coordinate {
        
        switch rotation {
            
        case .east: return Coordinate(x: (coordinate.z * -1), y: coordinate.y, z: coordinate.x)
            
        case .south: return Coordinate(x: (coordinate.x * -1), y: coordinate.y, z: (coordinate.z * -1))
            
        case .west: return Coordinate(x: coordinate.z, y: coordinate.y, z: (coordinate.x * -1))
            
        default: return Coordinate(x: coordinate.x, y: coordinate.y, z: coordinate.z)
        }
    }
}
