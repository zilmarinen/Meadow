//
//  Polytope.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public struct Polytope {

    public let vertices: [SCNVector3]
    
    public var peak: MDWFloat {
        
        return vertices.map{ $0.y }.max()!
    }
    
    public var base: MDWFloat {
        
        return vertices.map{ $0.y }.min()!
    }

    public var center: SCNVector3 {
        
        var x: MDWFloat = 0
        var y: MDWFloat = 0
        var z: MDWFloat = 0
        
        vertices.forEach { vertex in
            
            x += vertex.x
            y += vertex.y
            z += vertex.z
        }
        
        return SCNVector3(x: x / 4, y: y / 4, z: z / 4)
    }
    
    public init(v0: SCNVector3, v1: SCNVector3, v2: SCNVector3, v3: SCNVector3) {
        
        self.vertices = [v0, v1, v2, v3]
    }

    public init(x: MDWFloat, y0: Int, y1: Int, y2: Int, y3: Int, z: MDWFloat) {
        
        self.vertices = [SCNVector3(x: (x + Axis.halfUnitXZ), y: Axis.Y(y: y0), z: (z + Axis.halfUnitXZ)),
                         SCNVector3(x: (x + -Axis.halfUnitXZ), y: Axis.Y(y: y1), z: (z + Axis.halfUnitXZ)),
                         SCNVector3(x: (x + -Axis.halfUnitXZ), y: Axis.Y(y: y2), z: (z + -Axis.halfUnitXZ)),
                         SCNVector3(x: (x + Axis.halfUnitXZ), y: Axis.Y(y: y3), z: (z + -Axis.halfUnitXZ))]
    }
}

extension Polytope: Equatable {
    
    public static func ==(lhs: Polytope, rhs: Polytope) -> Bool {
        
        if lhs.vertices.count != rhs.vertices.count {
            
            return false
        }
        
        for index in 0..<lhs.vertices.count {
            
            let v0 = lhs.vertices[index]
            let v1 = rhs.vertices[index]
            
            if v0.x != v1.x || v0.y != v1.y || v0.z != v1.z {
                
                return false
            }
        }
        
        return true
    }
}

extension Polytope {

    public enum Elevation {
        
        case above
        case below
        case equal
        case intersecting
    }

    public func elevation(referencing polytope: Polytope) -> Elevation {
        
        var equal = true
        var above = true
        var below = true
        
        for index in 0..<min(polytope.vertices.count, vertices.count) {
            
            let v0 = polytope.vertices[index]
            let v1 = vertices[index]
            
            if v0.y != v1.y {
                
                equal = false
                
                if v0.y < v1.y {
                
                    below = false
                }
                else {
                    
                    above = false
                }
            }
        }
        
        if equal { return .equal }
        
        if above { return .above }
        
        if below { return .below }
        
        return .intersecting
    }
}

extension Polytope {
    
    public static func project(project: Polytope, against: Polytope) -> Polytope {
        
        let v0 = SCNVector3(x: against.vertices[0].x, y: project.vertices[0].y, z: against.vertices[0].z)
        let v1 = SCNVector3(x: against.vertices[1].x, y: project.vertices[1].y, z: against.vertices[1].z)
        let v2 = SCNVector3(x: against.vertices[2].x, y: project.vertices[2].y, z: against.vertices[2].z)
        let v3 = SCNVector3(x: against.vertices[3].x, y: project.vertices[3].y, z: against.vertices[3].z)
        
        return Polytope(v0: v0, v1: v1, v2: v2, v3: v3)
    }
    
    public static func invert(polytope: Polytope, edge: GridEdge) -> Polytope {
        
        let v0 = polytope.vertices[0]
        let v1 = polytope.vertices[1]
        let v2 = polytope.vertices[2]
        let v3 = polytope.vertices[3]
        
        switch edge {
            
            case .north,
                 .south:
                
            return Polytope(v0: v3, v1: v2, v2: v1, v3: v0)
            
            case .east,
                 .west:
                
            return Polytope(v0: v1, v1: v0, v2: v3, v3: v2)
        }
    }
    
    public static func inset(polytope: Polytope, edge: GridEdge, inset: MDWFloat) -> Polytope {
        
        let (c0, c1) = GridCorner.corners(edge: edge)
        
        let d0 = GridCorner.opposite(corner: c0)
        let d1 = GridCorner.opposite(corner: c1)
        
        let v2 = polytope.vertices[d0.rawValue]
        let v3 = polytope.vertices[d1.rawValue]
        
        let v0 = SCNVector3.lerp(from: polytope.vertices[c0.rawValue], to: v3, factor: inset)
        let v1 = SCNVector3.lerp(from: polytope.vertices[c1.rawValue], to: v2, factor: inset)
        
        switch edge {
            
        case .north:
        
            return Polytope(v0: v0, v1: v1, v2: polytope.vertices[2], v3: polytope.vertices[3])
            
        case .east:
            
            return Polytope(v0: polytope.vertices[0], v1: v0, v2: v1, v3: polytope.vertices[3])
            
        case .south:
            
            return Polytope(v0: polytope.vertices[0], v1: polytope.vertices[1], v2: v0, v3: v1)
            
        case .west:
            
            return Polytope(v0: v1, v1: polytope.vertices[1], v2: polytope.vertices[2], v3: v0)
            
        }
    }
    
    public static func offset(polytope: Polytope, y: MDWFloat) -> Polytope {
        
        let vector = SCNVector3(x: 0.0, y: y, z: 0.0)
        
        let v0 = polytope.vertices[0] + vector
        let v1 = polytope.vertices[1] + vector
        let v2 = polytope.vertices[2] + vector
        let v3 = polytope.vertices[3] + vector
        
        return Polytope(v0: v0, v1: v1, v2: v2, v3: v3)
    }
    
    public static func translate(polytope: Polytope, translation: SCNVector3) -> Polytope {
        
        let vertices = polytope.vertices.map { $0 + translation }
        
        return Polytope(v0: vertices[0], v1: vertices[1], v2: vertices[2], v3: vertices[3])
    }
}

extension Polytope {
    
    public func closest(corner vector: SCNVector3) -> GridCorner {
        
        var closestCorner = GridCorner.northWest
        
        var distance = MDWFloat(1.0)
        
        GridCorner.Corners.forEach { corner in
            
            let v0 = vertices[corner.rawValue]
            
            let delta = SCNVector3.length(vector: v0 - vector)
            
            if delta < distance {
                
                closestCorner = corner
                
                distance = delta
            }
        }
        
        return closestCorner
    }
    
    public func closest(edge vector: SCNVector3) -> GridEdge {
     
        var closestEdge = GridEdge.north
        
        var distance = MDWFloat(1.0)
        
        GridEdge.Edges.forEach { edge in
            
            let (c0, c1) = GridCorner.corners(edge: edge)
            
            let v0 = vertices[c0.rawValue]
            let v1 = vertices[c1.rawValue]
            
            let v2 = SCNVector3.lerp(from: v0, to: v1, factor: Axis.halfUnitXZ)
            
            let delta = SCNVector3.length(vector: v2 - vector)
            
            if delta < distance {
                
                closestEdge = edge
                
                distance = delta
            }
        }
        
        return closestEdge
    }
}

extension Polytope {
    
    public func centroid(for edge: GridEdge) -> SCNVector3 {
        
        let corners = GridCorner.corners(edge: edge)
        
        let v0 = vertices[corners.c0.rawValue]
        let v1 = vertices[corners.c1.rawValue]
        let v2 = center
        
        return SCNVector3(x: (v0.x + v1.x + v2.x) / 3, y: (v0.y + v1.y + v2.y) / 3, z: (v0.z + v1.z + v2.z) / 3)
    }
}
