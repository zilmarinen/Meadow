//
//  GridEdge.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

/*!
 @enum GridEdge
 @abstract Defines the 4 edges of a grid tile/node.
 */
public enum GridEdge: Int, Codable {
    
    case north
    case east
    case south
    case west
    
    /*!
     @property description
     @abstract Returns the string value of the GridEdge.
     */
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
    
    /*!
     @property Edges
     @abstract An array of GridEdges in clockwise order.
     */
    static var Edges: [GridEdge] { return [
    
        .north,
        .east,
        .south,
        .west
    ]}
    
    /*!
     @property Corners
     @abstract An array of GridEdges connected to a grid corner.
     */
    private static var Corners: [[GridEdge]] { return [
    
        [.north, .west],
        [.north, .east],
        [.east, .south],
        [.south, .west]
    ]}
    
    /*!
     @property Connected
     @abstract An array of GridEdges connected to each other in clockwise order.
     */
    private static var Connected: [[GridEdge]] { return [
        
        [.west, .east],
        [.north, .south],
        [.east, .west],
        [.south, .north]
    ]}
    
    /*!
     @property Opposite
     @abstract An array of GridEdges opposite to those defined by GridEdge.Edges.
     */
    private static var Opposite: [GridEdge] { return [
        
        .south,
        .west,
        .north,
        .east
    ]}
    
    /*!
     @property Normal
     @abstract An array of SCNVector3 defining the normal for each GridEdge.
     */
    private static var Normal: [SCNVector3] { return [
        
        SCNVector3.Forward,
        SCNVector3.Right,
        SCNVector3.Backward,
        SCNVector3.Left
    ]}
    
    /*!
     @method Edges:corner
     @abstract Return the two GridEdges connected to a given GridCorner.
     */
    static func Edges(corner: GridCorner) -> [GridEdge] {
        
        return Corners[corner.rawValue]
    }
    
    /*!
     @method Edges:edge
     @abstract Return the two GridEdges connected to a given GridEdge.
     */
    static func Edges(edge: GridEdge) -> [GridEdge] {
        
        return Connected[edge.rawValue]
    }
    
    /*!
     @method Opposite:edge
     @abstract Return the opposite GridEdges from a given GridEdge.
     */
    static func Opposite(edge: GridEdge) -> GridEdge {
        
        return Opposite[edge.rawValue]
    }
    
    /*!
     @method Normal:edge
     @abstract Return the SCNVector3 defining the normal for a given GridEdge.
     */
    static func Normal(edge: GridEdge) -> SCNVector3 {
        
        return Normal[edge.rawValue]
    }
    
    /*!
     @method Extent:edge
     @abstract Return the coordinate along a given GridEdge.
     */
    static func Extent(edge: GridEdge) -> Coordinate {
        
        return Coordinate.GridEdgeExtents[edge.rawValue]
    }
}

extension GridEdge {
    
    /*!
     @method Translate:vector:edge:translation
     @abstract Translates a vertex along the given GridEdge by the translation.
     @param vector The vector whose components should be translated.
     @param edge The GridEdge along which the vertex should be translated.
     @param translation The value defining the translation.
     */
    static func Translate(vector: SCNVector3, edge: GridEdge, translation: MDWFloat) -> SCNVector3 {
        
        let normal = Normal(edge: edge)
        
        return SCNVector3(x: vector.x + (normal.x * translation), y: vector.y, z: vector.z + (normal.z * translation))
    }
}
