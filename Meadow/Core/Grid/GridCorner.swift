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

    static func corners(edge: GridEdge) -> [GridCorner] {
        
        return Edges[edge.rawValue]
    }

    static func corners(corner: GridCorner) -> [GridCorner] {
        
        return Connected[corner.rawValue]
    }

    static func opposite(corner: GridCorner) -> GridCorner {
        
        return Opposite[corner.rawValue]
    }

    static func adjacent(corner: GridCorner, edge: GridEdge) -> GridCorner {
        
        let oppositeEdge = GridEdge.opposite(edge: edge)
        
        let oppositeCorner = GridCorner.opposite(corner: corner)
        
        let corners = GridCorner.corners(edge: oppositeEdge)
        
        return corners.filter { $0 != oppositeCorner }.first!
    }

    static func extent(corner: GridCorner) -> Coordinate {
        
        return Coordinate.GridCornerExtents[corner.rawValue]
    }
}
