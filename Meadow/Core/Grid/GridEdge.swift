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
    
    static var Edges: [GridEdge] { return [
    
        .north,
        .east,
        .south,
        .west
    ]}
    
    static var Corners: [[GridEdge]] { return [
    
        [.north, .west],
        [.north, .east],
        [.east, .south],
        [.south, .west]
    ]}
    
    static func Edges(corner: GridCorner) -> [GridEdge] {
        
        return Corners[corner.rawValue]
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
    
    static func Cardinal(edge: GridEdge) -> Coordinate {
        
        return Coordinate.Cardinal[edge.rawValue]
    }
}
