//
//  GridEdge.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public enum GridEdge: Int {
    
    case north
    case east
    case south
    case west
}

extension GridEdge {
    
    static var Edges: [GridEdge] { return Opposite.reversed() }
    
    private static var Cardinal: [Coordinate] { return [
        
        Coordinate.Forward,
        Coordinate.Right,
        Coordinate.Backward,
        Coordinate.Left
    ]}
    
    static func Cardinal(edge: GridEdge) -> Coordinate {
        
        return Cardinal[edge.rawValue]
    }
    
    private static var Opposite: [GridEdge] { return [
    
        .south,
        .west,
        .north,
        .east
    ]}
    
    static func Opposite(edge: GridEdge) -> GridEdge {
        
        return Opposite[edge.rawValue]
    }
}
