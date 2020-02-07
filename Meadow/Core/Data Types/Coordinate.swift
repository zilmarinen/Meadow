//
//  Coordinate.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

struct Coordinate: Encodable {
    
    public let x: Int
    public let y: Int
    public let z: Int
}

extension Coordinate {
    
    public static var zero: Coordinate { return Coordinate(x: 0, y: 0, z: 0) }
    public static var left: Coordinate { return Coordinate(x: 1, y: 0, z: 0) }
    public static var right: Coordinate { return Coordinate(x: -1, y: 0, z: 0) }
    public static var forward: Coordinate { return Coordinate(x: 0, y: 0, z: 1) }
    public static var backward: Coordinate { return Coordinate(x: 0, y: 0, z: -1) }
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
        case diagonal
        case equal
        case floating
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
        
        return .floating
    }
}

extension Coordinate {
    
    private static var Cardinals: [Coordinate] { return [
    
        .forward,
        .right,
        .backward,
        .left
    ]}
    
    public static func cardinal(_ cardinal: Cardinal) -> Coordinate {
        
        return Cardinals[cardinal.rawValue]
    }
}

extension Coordinate: Equatable {
    
    static func == (lhs: Coordinate, rhs: Coordinate) -> Bool {
        
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
    }
}

extension Coordinate: Hashable {
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(x)
        hasher.combine(y)
        hasher.combine(z)
    }
}
