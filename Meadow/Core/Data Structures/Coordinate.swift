//
//  Coordinate.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

/*!
 @struct Coordinate
 @abstract Defines a Coordinate with x, y and z components as an integer value.
 */
public struct Coordinate: Codable {
    
    /*!
     @property x
     @abstract The x component of the Coordinate.
     */
    public let x: Int
    
    /*!
     @property y
     @abstract The y component of the Coordinate.
     */
    public let y: Int
    
    /*!
     @property z
     @abstract The z component of the Coordinate.
     */
    public let z: Int
    
    /*!
     @method init:x:y:z
     @abstract Creates and initialises a Coordinate with the specified x, y and z components.
     @param x The x component of the Coordinate.
     @param y The y component of the Coordinate.
     @param z The z component of the Coordinate.
     */
    public init(x: Int, y: Int, z: Int) {
        
        self.x = x
        self.y = y
        self.z = z
    }
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

public extension Coordinate {
    
    /*!
     @property Zero
     @abstract Returns a Coordinate with the x, y and z components set to 0.
     */
    static var Zero: Coordinate { return Coordinate(x: 0, y: 0, z: 0) }
    
    /*!
     @property One
     @abstract Returns a Coordinate with the x, y and z components set to 1.
     */
    static var One: Coordinate { return Coordinate(x: 1, y: 1, z: 1) }
    
    /*!
     @property Up
     @abstract Returns a Coordinate with the x, y and z components set to 0, 1, 0.
     */
    static var Up: Coordinate { return Coordinate(x: 0, y: 1, z: 0) }
    
    /*!
     @property Down
     @abstract Returns a Coordinate with the x, y and z components set to 0, -1, 0.
     */
    static var Down: Coordinate { return Coordinate(x: 0, y: -1, z: 0) }
    
    /*!
     @property Left
     @abstract Returns a Coordinate with the x, y and z components set to 1, 0, 0.
     */
    static var Left: Coordinate { return Coordinate(x: 1, y: 0, z: 0) }
    
    /*!
     @property Right
     @abstract Returns a Coordinate with the x, y and z components set to -1, 0, 0.
     */
    static var Right: Coordinate { return Coordinate(x: -1, y: 0, z: 0) }
    
    /*!
     @property Forward
     @abstract Returns a Coordinate with the x, y and z components set to 0, 0, 1.
     */
    static var Forward: Coordinate { return Coordinate(x: 0, y: 0, z: 1) }
    
    /*!
     @property Backward
     @abstract Returns a Coordinate with the x, y and z components set to 0, 0, -1.
     */
    static var Backward: Coordinate { return Coordinate(x: 0, y: 0, z: -1) }
    
    /*!
     @property Cardinal
     @abstract Returns an array of Coordinates along each `GridEdge`.
     */
    static var Cardinal: [Coordinate] { return [
        
        Coordinate.Forward,
        Coordinate.Right,
        Coordinate.Backward,
        Coordinate.Left
    ]}
}

extension Coordinate {
    
    /*!
     @enum Adjacency
     @abstract Defines the relative adjacency of one Coordinate to another along the x and z axis.
     */
    enum Adjacency {
        
        case adjacent
        case diagonal
        case equal
        case detached
    }
    
    /*!
     @method adjacency:to
     @abstract Determines the adjacency of the Coordinate in reference to another Coordinate.
     @discussion Coordinate adjacency is determined by checking the x and z axis values of each Coordinate.
     */
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
