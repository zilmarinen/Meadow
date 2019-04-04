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
    
    public init(upperPolytope: Polytope, lowerPolytope: Polytope) {
        
        self.upperPolytope = upperPolytope
        self.lowerPolytope = lowerPolytope
    }
}

extension Polyhedron: Equatable {
    
    public static func ==(lhs: Polyhedron, rhs: Polyhedron) -> Bool {
        
        return lhs.upperPolytope == rhs.upperPolytope && lhs.lowerPolytope == rhs.lowerPolytope
    }
}

extension Polyhedron {
    
    var volume: Volume {
        
        let base = Axis.Y(y: lowerPolytope.base)
        let peak = Axis.Y(y: upperPolytope.peak)
        
        let center = lowerPolytope.center
        
        let coordinate = Coordinate(x: Int(center.x), y: base, z: Int(center.z))
        
        let size = Size(width: 1, height: (peak - base), depth: 1)
        
        return Volume(coordinate: coordinate, size: size)
    }
}

extension Polyhedron {
    
    public static func edge(polyhedron: Polyhedron, edge: GridEdge) -> Polytope {
        
        let corners = GridCorner.corners(edge: edge)
        
        return Polytope(v0: polyhedron.upperPolytope.vertices[corners.c0.rawValue], v1: polyhedron.upperPolytope.vertices[corners.c1.rawValue], v2: polyhedron.lowerPolytope.vertices[corners.c1.rawValue], v3: polyhedron.lowerPolytope.vertices[corners.c0.rawValue])
    }
}

extension Polyhedron {
    
    public enum Elevation {
        
        case above
        case below
        case enclosing
        case equal
        case intersecting
    }
    
    public func elevation(referencing polyhedron: Polyhedron) -> Elevation {
        
        let e0 = upperPolytope.elevation(referencing: polyhedron.lowerPolytope)
        let e1 = lowerPolytope.elevation(referencing: polyhedron.upperPolytope)
        
        if e0 == .below || e0 == .equal { return .below }
        if e1 == .above || e1 == .equal { return .above }
        
        let e2 = upperPolytope.elevation(referencing: polyhedron.upperPolytope)
        let e3 = lowerPolytope.elevation(referencing: polyhedron.lowerPolytope)
        
        if e2 == .equal && e3 == .equal { return .equal }
        
        if (e2 == .above || e2 == .equal) && (e3 == .below || e3 == .equal) { return .enclosing }
        
        return .intersecting
    }
}

extension Polyhedron {
    
    public static func invert(polyhedron: Polyhedron, edge: GridEdge) -> Polyhedron {
        
        return Polyhedron(upperPolytope: Polytope.invert(polytope: polyhedron.upperPolytope, edge: edge), lowerPolytope: Polytope.invert(polytope: polyhedron.lowerPolytope, edge: edge))
    }
    
    public static func stencil(polyhedrons: [Polyhedron], against: Polyhedron, edge: GridEdge) -> [Polyhedron] {
        
        let invertedPolyhedrons = polyhedrons.map { Polyhedron.invert(polyhedron: $0, edge: edge) }
        
        return subtract(polyhedrons: invertedPolyhedrons, from: against)
    }
    
    public static func subtract(polyhedron: Polyhedron, from: Polyhedron) -> [Polyhedron]? {
        
        switch from.elevation(referencing: polyhedron) {
            
        case .above,
             .below:
            
            return [from]
            
        case .enclosing:
            
            let e0 = polyhedron.upperPolytope.elevation(referencing: from.upperPolytope)
            let e1 = polyhedron.lowerPolytope.elevation(referencing: from.lowerPolytope)
            
            if e0 == .below && e1 == .above {
                
                let upperPolytope = Polytope.project(project: polyhedron.upperPolytope, against: from.upperPolytope)
                let lowerPolytope = Polytope.project(project: polyhedron.lowerPolytope, against: from.lowerPolytope)
                
                return [ Polyhedron(upperPolytope: from.upperPolytope, lowerPolytope: upperPolytope),
                         Polyhedron(upperPolytope: lowerPolytope, lowerPolytope: from.lowerPolytope) ]
            }
            
            let upperPolytope = Polytope.project(project: (e0 == .above || e0 == .equal ? polyhedron.lowerPolytope : from.upperPolytope), against: from.upperPolytope)
            let lowerPolytope = Polytope.project(project: (e1 == .below || e1 == .equal ? polyhedron.upperPolytope : from.lowerPolytope), against: from.lowerPolytope)
            
            return [ Polyhedron(upperPolytope: upperPolytope, lowerPolytope: lowerPolytope) ]
            
        case .intersecting:
            
            guard polyhedron.elevation(referencing: from) != .enclosing else { return nil }
            
            let e0 = polyhedron.upperPolytope.elevation(referencing: from.upperPolytope)
            let e1 = polyhedron.lowerPolytope.elevation(referencing: from.lowerPolytope)
            
            let upperPolytope = Polytope.project(project: (e0 == .above || e0 == .equal ? polyhedron.lowerPolytope : from.upperPolytope), against: from.upperPolytope)
            let lowerPolytope = Polytope.project(project: (e1 == .below || e1 == .equal ? polyhedron.upperPolytope : from.lowerPolytope), against: from.lowerPolytope)
            
            return [ Polyhedron(upperPolytope: upperPolytope, lowerPolytope: lowerPolytope) ]
            
        default: return nil
        }
    }
    
    public static func subtract(polyhedrons: [Polyhedron], from: Polyhedron) -> [Polyhedron] {
        
        var divisions = [from]
        
        polyhedrons.forEach { polyhedron in
            
            var remainder: [Polyhedron] = []
            
            divisions.forEach { division in
            
                if let result = subtract(polyhedron: polyhedron, from: division) {
                    
                    remainder.append(contentsOf: result)
                }
            }
            
            divisions = remainder
        }
        
        return divisions
    }
    
    public static func inset(polyhedron: Polyhedron, edge: GridEdge, inset: MDWFloat) -> Polyhedron {
        
        let upperPolytope = Polytope.inset(polytope: polyhedron.upperPolytope, edge: edge, inset: inset)
        let lowerPolytope = Polytope.inset(polytope: polyhedron.lowerPolytope, edge: edge, inset: inset)
        
        return Polyhedron(upperPolytope: upperPolytope, lowerPolytope: lowerPolytope)
    }
    
    public static func translate(polyhedron: Polyhedron, translation: SCNVector3) -> Polyhedron {
        
        let upperPolytope = Polytope.translate(polytope: polyhedron.upperPolytope, translation: translation)
        let lowerPolytope = Polytope.translate(polytope: polyhedron.lowerPolytope, translation: translation)
        
        return Polyhedron(upperPolytope: upperPolytope, lowerPolytope: lowerPolytope)
    }
}
