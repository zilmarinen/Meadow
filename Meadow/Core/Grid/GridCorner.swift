//
//  GridCorner.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

/*!
 @enum GridCorner
 @abstract Defines the 4 corners of a grid tile/node.
 */
public enum GridCorner: Int {
    
    case northWest
    case northEast
    case southEast
    case southWest
    
    /*!
     @property description
     @abstract Returns the string value of the GridCorner.
     */
    var description: String {
        
        switch self {
            
        case .northWest: return "North West"
        case .northEast: return "North East"
        case .southEast: return "South East"
        case .southWest: return "South West"
        }
    }
}

extension GridCorner {
    
    /*!
     @property Corners
     @abstract An array of grid corners in clockwise order.
     */
    static var Corners: [GridCorner] { return [
    
        .northWest,
        .northEast,
        .southEast,
        .southWest
    ]}
    
    /*!
     @property Edges
     @abstract An array of grid corners along each grid edge in clockwise order.
     */
    private static var Edges: [[GridCorner]] { return [
        
        [.northWest, .northEast],
        [.northEast, .southEast],
        [.southEast, .southWest],
        [.northWest, .southWest]
    ]}
    
    /*!
     @property Connected
     @abstract An array of grid corners connected to each other in clockwise order.
     */
    private static var Connected: [[GridCorner]] { return [
    
        [.northEast, .southWest],
        [.northWest, .southEast],
        [.northEast, .southWest],
        [.northWest, .southEast]
    ]}
    
    /*!
     @property Opposite
     @abstract An array of grid corners opposite to those defined by `GridCorner.Corners`.
     */
    private static var Opposite: [GridCorner] { return [
        
        .southEast,
        .southWest,
        .northWest,
        .northEast
    ]}
    
    /*!
     @method Corners:edge
     @abstract Return the two corners connected to a given edge.
     */
    static func Corners(edge: GridEdge) -> [GridCorner] {
        
        return Edges[edge.rawValue]
    }
    
    /*!
     @method Corners:corner
     @abstract Return the two corners connected to a given corner.
     */
    static func Corners(corner: GridCorner) -> [GridCorner] {
        
        return Connected[corner.rawValue]
    }
    
    /*!
     @method Opposite:corner
     @abstract Return the opposite corner diagonally from a given corner.
     */
    static func Opposite(corner: GridCorner) -> GridCorner {
        
        return Opposite[corner.rawValue]
    }
    
    /*!
     @method Adjacent:corner:edge
     @abstract Return the adjacent corner along a given edge.
     */
    static func Adjacent(corner: GridCorner, edge: GridEdge) -> GridCorner {
        
        let edges = GridEdge.Edges(corner: corner)
        
        if edges.contains(edge) {
            
            let perpendicularEdge = edges.filter { $0 != edge }.first!
            
            return Corners(edge: perpendicularEdge).filter { $0 != corner }.first!
        }
        
        return Opposite(corner: corner)
    }
}
