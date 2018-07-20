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

    static func Corners(edge: GridEdge) -> [GridCorner] {
        
        return Edges[edge.rawValue]
    }

    static func Corners(corner: GridCorner) -> [GridCorner] {
        
        return Connected[corner.rawValue]
    }

    static func Opposite(corner: GridCorner) -> GridCorner {
        
        return Opposite[corner.rawValue]
    }

    static func Adjacent(corner: GridCorner, edge: GridEdge) -> GridCorner {
        
        let oppositeEdge = GridEdge.Opposite(edge: edge)
        
        let oppositeCorner = GridCorner.Opposite(corner: corner)
        
        let corners = GridCorner.Corners(edge: oppositeEdge)
        
        return corners.filter { $0 != oppositeCorner }.first!
    }

    static func Extent(corner: GridCorner) -> Coordinate {
        
        return Coordinate.GridCornerExtents[corner.rawValue]
    }
}
