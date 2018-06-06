//
//  Polyhedron.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

/*!
 @struct Polyhedron
 @abstract Defines a Polyhedron with an upper and lower Polytope.
 */
public struct Polyhedron {
 
    /*!
     @property upperPolytope
     @abstract The upper Polytope of the Polyhedron.
     */
    public let upperPolytope: Polytope
    
    /*!
     @property lowerPolytope
     @abstract The lower Polytope of the Polyhedron.
     */
    public let lowerPolytope: Polytope
}

extension Polyhedron: Equatable {
    
    /*!
     @method ==
     @abstract Determine the equality of two Polyhedrons.
     */
    public static func ==(lhs: Polyhedron, rhs: Polyhedron) -> Bool {
        
        return lhs.upperPolytope == rhs.upperPolytope && lhs.lowerPolytope == rhs.lowerPolytope
    }
}

extension Polyhedron {
    
    /*!
     @enum Elevation
     @abstract Defines the relative elevation of one Polyhedron to another along the y axis.
     */
    enum Elevation {
        
        case above
        case below
        case equal
        case intersecting
    }
    
    /*!
     @method elevation:referencing
     @abstract Determines the elevation of the Polyhedron in reference to another Polyhedron.
     @discussion Polyhedron elevation is determined by checking the elevations of both upper and lower Polytopes.
     */
    func elevation(referencing polyhedron: Polyhedron) -> Elevation {
        
        if polyhedron.upperPolytope == upperPolytope && polyhedron.lowerPolytope == lowerPolytope {
         
            return .equal
        }
        
        let lowerElevation = lowerPolytope.elevation(referencing: polyhedron.upperPolytope)
        
        if lowerElevation == .above || lowerElevation == .equal {
            
            return .above
        }
        
        let upperElevation = upperPolytope.elevation(referencing: polyhedron.lowerPolytope)
        
        if upperElevation == .below || upperElevation == .equal {
            
            return .below
        }
        
        return .intersecting
    }
}

extension Polyhedron {
    
    /*!
     @method Invert:polyhedron:edge
     @abstract Invert the vertices of a Polyhedron along the specified edge.
     @param polyhedron The Polyhedron to be inverted.
     @param edge The edge along which the vertices should be inverted.
     */
    static func Invert(polyhedron: Polyhedron, edge: GridEdge) -> Polyhedron {
        
        return Polyhedron(upperPolytope: Polytope.Invert(polytope: polyhedron.upperPolytope, edge: edge), lowerPolytope: Polytope.Invert(polytope: polyhedron.lowerPolytope, edge: edge))
    }
    
    /*!
     @method Stencil:polyhedrons:from:edge
     @astract Attempts to subtract the volumes of an array of Polyhedrons from a single Polyhedron.
     @param subtract An array of Polyhedrons to subtract from the source Polyhedron.
     @param against The source Polyhedon to be divided into parts.
     @param edge The edge along which the Polyhedrons should be inverted.
     */
    static func Stencil(polyhedrons: [Polyhedron], against: Polyhedron, edge: GridEdge) -> [Polyhedron] {
        
        let invertedPolyhedrons = polyhedrons.map { Polyhedron.Invert(polyhedron: $0, edge: edge) }
        
        return Subtract(polyhedrons: invertedPolyhedrons, from: against)
    }
    
    /*!
     @method subtract:polyhedron:from
     @astract Attempts to subtract the volume of one Polyhedron from another.
     @param subtract The Polyhedron to subtract from the source Polyhedron.
     @param from The source Polyhedon to be divided into parts.
     */
    static func Subtract(polyhedron: Polyhedron, from: Polyhedron) -> [Polyhedron]? {
        
        switch polyhedron.elevation(referencing: from) {
            
        case .intersecting:
            
            if polyhedron.upperPolytope.elevation(referencing: from.upperPolytope) == .below && polyhedron.lowerPolytope.elevation(referencing: from.lowerPolytope) == .above {
                
                let upperPolytope = Polytope.Project(project: polyhedron.upperPolytope, against: from.upperPolytope)
                let lowerPolytope = Polytope.Project(project: polyhedron.lowerPolytope, against: from.lowerPolytope)
                
                return [ Polyhedron(upperPolytope: from.upperPolytope, lowerPolytope: upperPolytope),
                         Polyhedron(upperPolytope: lowerPolytope, lowerPolytope: from.lowerPolytope) ]
            }
            
            switch polyhedron.upperPolytope.elevation(referencing: from.upperPolytope) {
                
            case .above,
                 .equal:
                
                let upperPolytope = Polytope.Project(project: polyhedron.lowerPolytope, against: from.lowerPolytope)
                
                return [ Polyhedron(upperPolytope: upperPolytope, lowerPolytope: from.lowerPolytope) ]
                
            default:
                
                if polyhedron.upperPolytope.elevation(referencing: from.lowerPolytope) == .above {
                
                    let lowerPolytope = Polytope.Project(project: polyhedron.upperPolytope, against: from.upperPolytope)
                    
                    return [ Polyhedron(upperPolytope: from.upperPolytope, lowerPolytope: lowerPolytope) ]
                }
            }
            
        default: break
        }
        
        return nil
    }
    
    /*!
     @method subtract:polyhedrons:from
     @astract Attempts to subtract the volumes of an array of Polyhedrons from a single Polyhedron.
     @param subtract An array of Polyhedrons to subtract from the source Polyhedron.
     @param from The source Polyhedon to be divided into parts.
     */
    static func Subtract(polyhedrons: [Polyhedron], from: Polyhedron) -> [Polyhedron] {
        
        var divisions = [from]
        
        polyhedrons.forEach { polyhedron in
            
            var remainder: [Polyhedron] = []
            
            divisions.forEach { division in
            
                if let result = Subtract(polyhedron: polyhedron, from: division) {
                    
                    remainder.append(contentsOf: result)
                }
                else {
                    
                    remainder.append(division)
                }
            }
            
            divisions = remainder
        }
        
        return divisions
    }
}
