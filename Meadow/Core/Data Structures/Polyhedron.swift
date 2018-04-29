//
//  Polyhedron.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public struct Polyhedron {
 
    let upperPolytope: Polytope
    let lowerPolytope: Polytope
}

extension Polyhedron: Equatable {
    
    public static func ==(lhs: Polyhedron, rhs: Polyhedron) -> Bool {
        
        return lhs.upperPolytope == rhs.upperPolytope && lhs.lowerPolytope == rhs.lowerPolytope
    }
}

extension Polyhedron {
    
    enum Elevation {
        
        case above
        case below
        case equal
        case intersecting
    }
    
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
