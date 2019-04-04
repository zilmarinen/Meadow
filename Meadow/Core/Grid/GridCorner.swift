//
//  GridCorner.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public enum GridCorner: Int {
    
    public typealias Pair = (c0: GridCorner, c1: GridCorner)
    
    case northWest
    case northEast
    case southEast
    case southWest
    
    public var description: String {
        
        switch self {
            
        case .northWest: return "North West"
        case .northEast: return "North East"
        case .southEast: return "South East"
        case .southWest: return "South West"
        }
    }
}

extension GridCorner {
    
    static var Corners: [GridCorner] { return [
    
        .northWest,
        .northEast,
        .southEast,
        .southWest
    ]}
    
    private static var Edges: [[GridCorner]] { return [
        
        [.northWest, .northEast],
        [.northEast, .southEast],
        [.southEast, .southWest],
        [.southWest, .northWest]
    ]}
    
    private static var Connected: [[GridCorner]] { return [
    
        [.southWest, .northEast],
        [.northWest, .southEast],
        [.northEast, .southWest],
        [.southEast, .northWest]
    ]}

    private static var Opposite: [GridCorner] { return [
        
        .southEast,
        .southWest,
        .northWest,
        .northEast
    ]}

    public static func corners(edge: GridEdge) -> Pair {
        
        return (Edges[edge.rawValue].first!, Edges[edge.rawValue].last!)
    }

    public static func corners(corner: GridCorner) -> Pair {
        
        return (Connected[corner.rawValue].first!, Connected[corner.rawValue].last!)
    }

    public static func opposite(corner: GridCorner) -> GridCorner {
        
        return Opposite[corner.rawValue]
    }

    public static func adjacent(corner: GridCorner, edge: GridEdge) -> GridCorner {
        
        let oppositeEdge = GridEdge.opposite(edge: edge)
        
        let oppositeCorner = GridCorner.opposite(corner: corner)
        
        let (c0, c1) = GridCorner.corners(edge: oppositeEdge)
        
        return (c0 != oppositeCorner ? c0 : c1)
    }

    public static func extent(corner: GridCorner) -> Coordinate {
        
        return Coordinate.GridCornerExtents[corner.rawValue]
    }
}
