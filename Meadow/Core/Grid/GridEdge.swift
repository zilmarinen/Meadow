//
//  GridEdge.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public enum GridEdge: Int, Codable {
    
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

    static var Edges: [GridEdge] { return [
    
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

    static func edges(corner: GridCorner) -> [GridEdge] {
        
        return Corners[corner.rawValue]
    }

    static func edges(edge: GridEdge) -> [GridEdge] {
        
        return Connected[edge.rawValue]
    }

    static func opposite(edge: GridEdge) -> GridEdge {
        
        return Opposite[edge.rawValue]
    }

    static func normal(edge: GridEdge) -> SCNVector3 {
        
        return Normal[edge.rawValue]
    }

    static func extent(edge: GridEdge) -> Coordinate {
        
        return Coordinate.GridEdgeExtents[edge.rawValue]
    }
}

extension GridEdge {

    static func translate(vector: SCNVector3, edge: GridEdge, translation: MDWFloat) -> SCNVector3 {
        
        let edgeNormal = normal(edge: edge)
        
        return SCNVector3(x: vector.x + (edgeNormal.x * translation), y: vector.y, z: vector.z + (edgeNormal.z * translation))
    }
}
