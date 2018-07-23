//
//  Polytope.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public struct Polytope {

    let vertices: [SCNVector3]
    
    var peak: MDWFloat {
        
        return vertices.map{ $0.y }.max()!
    }
    
    var base: MDWFloat {
        
        return vertices.map{ $0.y }.min()!
    }

    var center: SCNVector3 {
        
        let count = MDWFloat(vertices.count)
        var x: MDWFloat = 0
        var y: MDWFloat = 0
        var z: MDWFloat = 0
        
        vertices.forEach { vertex in
            
            x += vertex.x
            y += vertex.y
            z += vertex.z
        }
        
        return SCNVector3(x: (x / count), y: (y / count), z: (z / count))
    }
    
    public init?(vertices: [SCNVector3]) {
        
        guard vertices.count == 4 else { return nil }
        
        self.vertices = vertices
    }

    public init?(x: MDWFloat, corners: [Int], z: MDWFloat) {
        
        guard corners.count == 4 else { return nil }
        
        let halfWidth = MDWFloat(Axis.unitXZ / 2.0)
        
        self.vertices = [SCNVector3(x: (x + halfWidth), y: Axis.Y(y: corners[0]), z: (z + halfWidth)),
                         SCNVector3(x: (x + -halfWidth), y: Axis.Y(y: corners[1]), z: (z + halfWidth)),
                         SCNVector3(x: (x + -halfWidth), y: Axis.Y(y: corners[2]), z: (z + -halfWidth)),
                         SCNVector3(x: (x + halfWidth), y: Axis.Y(y: corners[3]), z: (z + -halfWidth))]
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

    enum Elevation {
        
        case above
        case below
        case equal
        case intersecting
    }

    func elevation(referencing polytope: Polytope) -> Elevation {
        
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
    
    static func project(project: Polytope, against: Polytope) -> Polytope {
        
        let v0 = SCNVector3(x: against.vertices[0].x, y: project.vertices[0].y, z: against.vertices[0].z)
        let v1 = SCNVector3(x: against.vertices[1].x, y: project.vertices[1].y, z: against.vertices[1].z)
        let v2 = SCNVector3(x: against.vertices[2].x, y: project.vertices[2].y, z: against.vertices[2].z)
        let v3 = SCNVector3(x: against.vertices[3].x, y: project.vertices[3].y, z: against.vertices[3].z)
        
        return Polytope(vertices: [ v0, v1, v2, v3 ])!
    }
    
    static func invert(polytope: Polytope, edge: GridEdge) -> Polytope {
        
        let v0 = polytope.vertices[0]
        let v1 = polytope.vertices[1]
        let v2 = polytope.vertices[2]
        let v3 = polytope.vertices[3]
        
        switch edge {
            
            case .north,
                 .south:
                
            return Polytope(vertices: [v3, v2, v1, v0])!
            
            case .east,
                 .west:
                
            return Polytope(vertices: [v1, v0, v3, v2])!
        }
    }
}

extension Polytope {
    
    static func translate(polytope: Polytope, translation: SCNVector3) -> Polytope {
        
        let v0 = SCNVector3(x: polytope.vertices[0].x + translation.x, y: polytope.vertices[0].y + translation.y, z: polytope.vertices[0].z + translation.z)
        let v1 = SCNVector3(x: polytope.vertices[1].x + translation.x, y: polytope.vertices[1].y + translation.y, z: polytope.vertices[1].z + translation.z)
        let v2 = SCNVector3(x: polytope.vertices[2].x + translation.x, y: polytope.vertices[2].y + translation.y, z: polytope.vertices[2].z + translation.z)
        let v3 = SCNVector3(x: polytope.vertices[3].x + translation.x, y: polytope.vertices[3].y + translation.y, z: polytope.vertices[3].z + translation.z)
        
        return Polytope(vertices: [ v0, v1, v2, v3 ])!
    }
}

extension Polytope {
    
    static func inset(polytope: Polytope, edge: GridEdge, inset: MDWFloat) -> Polytope {
        
        let oppositeEdge = GridEdge.opposite(edge: edge)
        
        switch edge {
            
        case .north:
        
            let v0 = GridEdge.translate(vector: polytope.vertices[0], edge: oppositeEdge, translation: inset)
            let v1 = GridEdge.translate(vector: polytope.vertices[1], edge: oppositeEdge, translation: inset)
            
            return Polytope(vertices: [v0, v1, polytope.vertices[2], polytope.vertices[3]])!
            
        case .east:
            
            let v1 = GridEdge.translate(vector: polytope.vertices[1], edge: oppositeEdge, translation: inset)
            let v2 = GridEdge.translate(vector: polytope.vertices[2], edge: oppositeEdge, translation: inset)
            
            return Polytope(vertices: [polytope.vertices[0], v1, v2, polytope.vertices[3]])!
            
        case .south:
            
            let v2 = GridEdge.translate(vector: polytope.vertices[2], edge: oppositeEdge, translation: inset)
            let v3 = GridEdge.translate(vector: polytope.vertices[3], edge: oppositeEdge, translation: inset)
            
            return Polytope(vertices: [polytope.vertices[0], polytope.vertices[1], v2, v3])!
            
        case .west:
            
            let v0 = GridEdge.translate(vector: polytope.vertices[0], edge: oppositeEdge, translation: inset)
            let v3 = GridEdge.translate(vector: polytope.vertices[3], edge: oppositeEdge, translation: inset)
            
            return Polytope(vertices: [v0, polytope.vertices[1], polytope.vertices[2], v3])!
            
        }
    }
}
