//
//  GridMesh.swift
//  Meadow
//
//  Created by Zack Brown on 10/07/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Pasture

struct GridMesh {
    
    struct Elevation: Comparable {
        
        let elevation: Int
        let vector: Vector
        
        init(elevation: Int, vector: Vector) {
            
            self.elevation = elevation
            self.vector = Vector(vector: vector, elevation: World.Constants.floor + elevation)
        }
        
        static func < (lhs: Elevation, rhs: Elevation) -> Bool {
        
            return lhs.elevation < rhs.elevation
        }
    }
    
    struct Polytope {
        
        let p0: Elevation
        let p1: Elevation
        let p2: Elevation
        
        var normal: Vector { return (p0.vector - p1.vector).cross(vector: p0.vector - p2.vector) }
    }
    

    struct Polyhedron {
        
        let upper: Polytope
        let lower: Polytope
    }
    
    struct EdgeSegment {
        
        let p0: Elevation
        let p1: Elevation
        
        init(e0: Int, v0: Vector, e1: Int, v1: Vector) {
            
            self.p0 = Elevation(elevation: e0, vector: v0)
            self.p1 = Elevation(elevation: e1, vector: v1)
        }
        
        init(p0: Elevation, p1: Elevation) {
            
            self.p0 = p0
            self.p1 = p1
        }
    }
    
    struct Face {
        
        enum Facet {
            
            case front
            case right
            case left
        }
        
        let face: Facet
        
        let upper: EdgeSegment
        let lower: EdgeSegment
        
        let normal: Vector
        
        init(face: Facet, upper: EdgeSegment, lower: EdgeSegment, normal: Vector) {
            
            self.face = face
            
            self.upper = upper
            self.lower = lower
            
            self.normal = normal
        }
        
        init(polyhedron: Polyhedron, face: Facet, normal: Vector) {
            
            self.face = face
            
            self.normal = normal
            
            switch face {
                
            case .front:
                
                self.upper = EdgeSegment(p0: polyhedron.upper.p0, p1: polyhedron.upper.p2)
                self.lower = EdgeSegment(p0: polyhedron.lower.p0, p1: polyhedron.lower.p2)
                
            case .right:
                
                self.upper = EdgeSegment(p0: polyhedron.upper.p2, p1: polyhedron.upper.p1)
                self.lower = EdgeSegment(p0: polyhedron.lower.p2, p1: polyhedron.lower.p1)
                
            case .left:
                
                self.upper = EdgeSegment(p0: polyhedron.upper.p1, p1: polyhedron.upper.p0)
                self.lower = EdgeSegment(p0: polyhedron.lower.p1, p1: polyhedron.lower.p0)
            }
        }
        
        func clip(intersection: EdgeSegment) -> Face? {
            
            guard (intersection.p0 >= lower.p0 && intersection.p0 < upper.p0) || (intersection.p1 >= lower.p1 && intersection.p1 < upper.p1) else { return nil }
            
            let e0 = min(max(intersection.p0, lower.p0), upper.p0)
            let e1 = min(max(intersection.p1, lower.p1), upper.p1)
            
            let lower = EdgeSegment(p0: e0, p1: e1)
            
            guard upper.p0.elevation != lower.p0.elevation || upper.p1.elevation != lower.p1.elevation else { return nil }
            
            return Face(face: face, upper: upper, lower: lower, normal: normal)
        }
    }
}
