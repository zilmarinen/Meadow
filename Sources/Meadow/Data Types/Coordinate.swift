//
//  Coordinate.swift
//
//  Created by Zack Brown on 02/11/2020.
//

import Euclid
import Foundation

public struct Coordinate: Codable, Equatable, Hashable, Identifiable {
    
    public let x: Int
    public let y: Int
    public let z: Int
    
    public var id: String { "[\(x), \(y), \(z)]" }
    
    var position: Position { Position(x: Double(x), y: Double(y) * World.Constants.slope, z: Double(z)) }
    
    public var xz: Coordinate { Coordinate(x: x, y: 0, z: z) }
    
    public init(x: Int, y: Int, z: Int) {
        
        self.x = x
        self.y = y
        self.z = z
    }
    
    public init(position: Position) {
        
        self.init(x: Int(position.x), y: Int(position.y), z: Int(position.z))
    }
}

public extension Coordinate {
    
    static var zero = Coordinate(x: 0, y: 0, z: 0)
    static var right = Coordinate(x: 1, y: 0, z: 0)
    static var up = Coordinate(x: 0, y: 1, z: 0)
    static var forward = Coordinate(x: 0, y: 0, z: -1)
    static var infinity = Coordinate(x: .max, y: .max, z: .max)
}

public extension Coordinate {
    
    static prefix func -(rhs: Self) -> Self {
        
        return Coordinate(x: -rhs.x, y: -rhs.y, z: -rhs.z)
    }
    
    static func +(lhs: Coordinate, rhs: Coordinate) -> Coordinate {
        
        return Coordinate(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }
    
    static func -(lhs: Coordinate, rhs: Coordinate) -> Coordinate {
        
        return Coordinate(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
    }
    
    static func +=(lhs: inout Self, rhs: Self) {
        
        lhs = lhs + rhs
    }
    
    static func minimum(lhs: Self, rhs: Self) -> Self {
        
        return Coordinate(x: min(lhs.x, rhs.x), y: min(lhs.y, rhs.y), z: min(lhs.z, rhs.z))
    }
    
    static func maximum(lhs: Self, rhs: Self) -> Self {
        
        return Coordinate(x: max(lhs.x, rhs.x), y: max(lhs.y, rhs.y), z: max(lhs.z, rhs.z))
    }
}

extension Coordinate {
    
    public enum Adjacency {
        
        case adjacent
        case adrift
        case diagonal
        case equal
    }
    
    public func adjacency(to coordinate: Coordinate) -> Adjacency {
        
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
    
    func direction(to coordinate: Coordinate) -> Direction {
        
        if x == coordinate.x {
            
            return z > coordinate.z ? Cardinal.north.direction : Cardinal.south.direction
        }
        
        return x > coordinate.x ? Cardinal.west.direction : Cardinal.east.direction
    }
}

extension Coordinate {
    
    func rotate(rotation: Cardinal) -> Coordinate {
        
        switch rotation {
            
        case .east: return Coordinate(x: (z * -1), y: y, z: x)
            
        case .south: return Coordinate(x: (x * -1), y: y, z: (z * -1))
            
        case .west: return Coordinate(x: z, y: y, z: (x * -1))
            
        default: return Coordinate(x: x, y: y, z: z)
        }
    }
}

extension Coordinate {
    
    public func heuristic(coordinate: Coordinate) -> Double {
        
        return sqrt(pow(Double(x - coordinate.x), 2) + pow(Double(y - coordinate.y), 2) + pow(Double(z - coordinate.z), 2))
    }
}
