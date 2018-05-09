//
//  GridCorner.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public enum GridCorner: Int {
    
    case northWest
    case northEast
    case southEast
    case southWest
}

extension GridCorner {
    
    static var Corners: [GridCorner] { return [
    
        .northWest,
        .northEast,
        .southEast,
        .southWest
    ]}
    
    static var Edges: [[GridCorner]] { return [
        
        [.northWest, .northEast],
        [.northEast, .southEast],
        [.southEast, .southWest],
        [.northWest, .southWest]
    ]}
    
    static var Connected: [[GridCorner]] { return [
    
        [.northEast, .southWest],
        [.northWest, .southEast],
        [.northEast, .southWest],
        [.northWest, .southEast]
    ]}
    
    static func Corners(corner: GridCorner) -> [GridCorner] {
        
        return Connected[corner.rawValue]
    }
    
    static func Corners(edge: GridEdge) -> [GridCorner] {
        
        return Edges[edge.rawValue]
    }
    
    private static var Opposite: [GridCorner] { return [
    
        .southEast,
        .southWest,
        .northWest,
        .northEast
    ]}
    
    static func Opposite(corner: GridCorner) -> GridCorner {
        
        return Opposite[corner.rawValue]
    }
}
