//
//  GridEdge.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public enum GridEdge: Int, Codable {
    
    public typealias Pair = (e0: GridEdge, e1: GridEdge)
    
    case north
    case east
    case south
    case west

    public var description: String {
        
        switch self {
            
        case .north: return "North"
        case .east: return "East"
        case .south: return "South"
        case .west: return "West"
        }
    }
}

extension GridEdge {

    public static var Edges: [GridEdge] { return [
    
        .north,
        .east,
        .south,
        .west
    ]}
    
    private static var Corners: [[GridEdge]] { return [
    
        [.north, .west],
        [.north, .east],
        [.east, .south],
        [.south, .west]
    ]}

    private static var Connected: [[GridEdge]] { return [
        
        [.west, .east],
        [.north, .south],
        [.east, .west],
        [.south, .north]
    ]}

    private static var Opposite: [GridEdge] { return [
        
        .south,
        .west,
        .north,
        .east
    ]}

    private static var Normal: [SCNVector3] { return [
        
        SCNVector3.Forward,
        SCNVector3.Right,
        SCNVector3.Backward,
        SCNVector3.Left
    ]}

    public static func edges(corner: GridCorner) -> Pair {
        
        return (Corners[corner.rawValue].first!, Corners[corner.rawValue].last!)
    }

    public static func edges(edge: GridEdge) -> Pair {
        
        return (Connected[edge.rawValue].first!, Connected[edge.rawValue].last!)
    }

    public static func opposite(edge: GridEdge) -> GridEdge {
        
        return Opposite[edge.rawValue]
    }
    
    public static func inverse(edge: GridEdge) -> [GridEdge] {
        
        return Edges.compactMap { $0 != edge ? $0 : nil }
    }

    public static func normal(edge: GridEdge) -> SCNVector3 {
        
        return Normal[edge.rawValue]
    }

    public static func extent(edge: GridEdge) -> Coordinate {
        
        return Coordinate.GridEdgeExtents[edge.rawValue]
    }
}

extension GridEdge {
    
    public static func rotate(edge: GridEdge, rotation: GridEdge) -> GridEdge {
        
        var value = (edge.rawValue + rotation.rawValue)
        
        value = (value > 3 ? (value - 4) : value)
        
        return GridEdge(rawValue: value)!
    }
    
    var next: GridEdge {
        
        switch self {
            
        case .north: return .east
        case .east: return .south
        case .south: return .west
        case .west: return .north
        }
    }
    
    var previous: GridEdge {
        
        switch self {
            
        case .north: return .west
        case .east: return .north
        case .south: return .east
        case .west: return .south
        }
    }
}
