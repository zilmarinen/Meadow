//
//  Coordinate.swift
//
//  Created by Zack Brown on 02/11/2020.
//

public struct Coordinate: Codable, Equatable, Hashable {
    
    public let x: Int
    public let y: Int
    public let z: Int
    
    var description: String {
        
        return "[\(x), \(y), \(z)]"
    }
    
    public init(x: Int, y: Int, z: Int) {
        
        self.x = x
        self.y = y
        self.z = z
    }
    
    public init(x: Int, z: Int, size: Int) {
        
        self.x = Int((x >= 0 ? x : x - size) / size) * size
        self.y = 0
        self.z = Int((z >= 0 ? z : z - size) / size) * size
    }
    
    public init(vector: Vector) {
        
        self.init(x: Int(vector.x), y: Int(vector.y), z: Int(vector.z))
    }
}

public extension Coordinate {
    
    static var zero = Coordinate(x: 0, y: 0, z: 0)
    static var left = -right
    static var right = Coordinate(x: 1, y: 0, z: 0)
    static var forward = Coordinate(x: 0, y: 0, z: 1)
    static var backward = -forward
    static var up = Coordinate(x: 0, y: 1, z: 0)
    static var down = -up
    
    var xz: Coordinate { Coordinate(x: x, y: 0, z: z) }
}

extension Coordinate {
    
    static prefix func -(rhs: Self) -> Self {
        
        return Coordinate(x: -rhs.x, y: -rhs.y, z: -rhs.z)
    }
    
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
    
    func rotate(rotation: Cardinal) -> Coordinate {
        
        switch rotation {
            
        case .east: return Coordinate(x: (z * -1), y: y, z: x)
            
        case .south: return Coordinate(x: (x * -1), y: y, z: (z * -1))
            
        case .west: return Coordinate(x: z, y: y, z: (x * -1))
            
        default: return Coordinate(x: x, y: y, z: z)
        }
    }
}
