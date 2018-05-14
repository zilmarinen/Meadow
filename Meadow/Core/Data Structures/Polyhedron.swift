//
//  Polyhedron.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

/*!
 @struct Polyhedron
 @abstract Defines a Polyhedron with an upper and lower Polytope.
 */
public struct Polyhedron {
 
    /*!
     @property upperPolytope
     @abstract The upper Polytope of the Polyhedron.
     */
    let upperPolytope: Polytope
    
    /*!
     @property lowerPolytope
     @abstract The lower Polytope of the Polyhedron.
     */
    let lowerPolytope: Polytope
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
