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
     @abstract An array of grid edges in clockwise order.
     */
    static var Edges: [GridEdge] { return [
    
        .north,
        .east,
        .south,
        .west
    ]}
    
    /*!
     @property Corners
     @abstract An array of grid edges connected to a grid corner.
     */
    private static var Corners: [[GridEdge]] { return [
    
        [.north, .west],
        [.north, .east],
        [.east, .south],
        [.south, .west]
    ]}
    
    /*!
     @property Connected
     @abstract An array of grid edges connected to each other in clockwise order.
     */
    private static var Connected: [[GridEdge]] { return [
        
        [.east, .west],
        [.north, .south],
        [.east, .west],
        [.north, .south]
    ]}
    
    /*!
     @property Opposite
     @abstract An array of grid edges opposite to those defined by `GridEdge.Edges`.
     */
    private static var Opposite: [GridEdge] { return [
        
        .south,
        .west,
        .north,
        .east
    ]}
    
    /*!
     @property Normal
     @abstract An array of SCNVector3 defining the normal for each edge.
     */
    private static var Normal: [SCNVector3] { return [
        
        SCNVector3.Forward,
        SCNVector3.Right,
        SCNVector3.Backward,
        SCNVector3.Left
    ]}
    
    /*!
     @method Edges:corner
     @abstract Return the two edges connected to a given corner.
     */
    static func Edges(corner: GridCorner) -> [GridEdge] {
        
        return Corners[corner.rawValue]
    }
    
    /*!
     @method Edges:edge
     @abstract Return the two edges connected to a given edge.
     */
    static func Edges(edge: GridEdge) -> [GridEdge] {
        
        return Connected[edge.rawValue]
    }
    
    /*!
     @method Opposite:edge
     @abstract Return the opposite edge from a given edge.
     */
    static func Opposite(edge: GridEdge) -> GridEdge {
        
        return Opposite[edge.rawValue]
    }
    
    /*!
     @method Normal:edge
     @abstract Return the SCNVector3 defining the normal for a given edge.
     */
    static func Normal(edge: GridEdge) -> SCNVector3 {
        
        return Normal[edge.rawValue]
    }
    
    /*!
     @method Cardinal:edge
     @abstract Return the cardinal coordinate along a given edge.
     */
    static func Cardinal(edge: GridEdge) -> Coordinate {
        
        return Coordinate.Cardinal[edge.rawValue]
    }
}
