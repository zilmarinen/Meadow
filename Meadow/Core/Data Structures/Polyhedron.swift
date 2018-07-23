//
//  Polyhedron.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public struct Polyhedron {
 
    public let upperPolytope: Polytope
    
    public let lowerPolytope: Polytope
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

extension Polyhedron {
    
    static func invert(polyhedron: Polyhedron, edge: GridEdge) -> Polyhedron {
        
        return Polyhedron(upperPolytope: Polytope.invert(polytope: polyhedron.upperPolytope, edge: edge), lowerPolytope: Polytope.invert(polytope: polyhedron.lowerPolytope, edge: edge))
    }
    
    static func stencil(polyhedrons: [Polyhedron], against: Polyhedron, edge: GridEdge) -> [Polyhedron] {
        
        let invertedPolyhedrons = polyhedrons.map { Polyhedron.invert(polyhedron: $0, edge: edge) }
        
        return subtract(polyhedrons: invertedPolyhedrons, from: against)
    }
    
    static func subtract(polyhedron: Polyhedron, from: Polyhedron) -> [Polyhedron]? {
        
        switch polyhedron.elevation(referencing: from) {
            
        case .intersecting:
            
            if polyhedron.upperPolytope.elevation(referencing: from.upperPolytope) == .below && polyhedron.lowerPolytope.elevation(referencing: from.lowerPolytope) == .above {
                
                let upperPolytope = Polytope.project(project: polyhedron.upperPolytope, against: from.upperPolytope)
                let lowerPolytope = Polytope.project(project: polyhedron.lowerPolytope, against: from.lowerPolytope)
                
                return [ Polyhedron(upperPolytope: from.upperPolytope, lowerPolytope: upperPolytope),
                         Polyhedron(upperPolytope: lowerPolytope, lowerPolytope: from.lowerPolytope) ]
            }
            
            switch polyhedron.upperPolytope.elevation(referencing: from.upperPolytope) {
                
            case .above,
                 .equal:
                
                let upperPolytope = Polytope.project(project: polyhedron.lowerPolytope, against: from.lowerPolytope)
                
                return [ Polyhedron(upperPolytope: upperPolytope, lowerPolytope: from.lowerPolytope) ]
                
            default:
                
                if polyhedron.upperPolytope.elevation(referencing: from.lowerPolytope) == .above {
                
                    let lowerPolytope = Polytope.project(project: polyhedron.upperPolytope, against: from.upperPolytope)
                    
                    return [ Polyhedron(upperPolytope: from.upperPolytope, lowerPolytope: lowerPolytope) ]
                }
            }
            
        default: break
        }
        
        return nil
    }
    
    static func subtract(polyhedrons: [Polyhedron], from: Polyhedron) -> [Polyhedron] {
        
        var divisions = [from]
        
        polyhedrons.forEach { polyhedron in
            
            var remainder: [Polyhedron] = []
            
            divisions.forEach { division in
            
                if let result = subtract(polyhedron: polyhedron, from: division) {
                    
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

extension Polyhedron {
    
    static func translate(polyhedron: Polyhedron, translation: SCNVector3) -> Polyhedron {
        
        let upperPolytope = Polytope.translate(polytope: polyhedron.upperPolytope, translation: translation)
        let lowerPolytope = Polytope.translate(polytope: polyhedron.lowerPolytope, translation: translation)
        
        return Polyhedron(upperPolytope: upperPolytope, lowerPolytope: lowerPolytope)
    }
}

extension Polyhedron {
    
    static func inset(polyhedron: Polyhedron, edge: GridEdge, inset: MDWFloat) -> Polyhedron {
        
        let upperPolytope = Polytope.inset(polytope: polyhedron.upperPolytope, edge: edge, inset: inset)
        let lowerPolytope = Polytope.inset(polytope: polyhedron.lowerPolytope, edge: edge, inset: inset)
        
        return Polyhedron(upperPolytope: upperPolytope, lowerPolytope: lowerPolytope)
    }
}
