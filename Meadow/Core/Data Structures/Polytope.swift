//
//  Polytope.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

/*!
 @struct Polytope
 @abstract Defines a Polytope with an array of vertices.
 */
public struct Polytope {
    
    /*!
     @property vertices
     @abstract The vertices defining the Polytope.
     */
    let vertices: [SCNVector3]
    
    /*!
     @property peak
     @abstract The greatest y axis value of the Polytopes vertices.
     */
    var peak: MDWFloat {
        
        return vertices.map{ $0.y }.max()!
    }
    
    /*!
     @property base
     @abstract The lowest y axis value of the Polytopes vertices.
     */
    var base: MDWFloat {
        
        return vertices.map{ $0.y }.min()!
    }
    
    /*!
     @property center
     @abstract The calculated center of the Polytope vertices.
     */
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
    
    /*!
     @method init:vertices
     @abstract Creates and initialises a Polytope with the specified vertices.
     @param vertices The vertices defining the Polytope.
     */
    public init(vertices: [SCNVector3]) {
        
        self.vertices = vertices
    }
    
    /*!
     @method init:x:y:z
     @abstract Creates and initialises a Polytope with unit length at the specified x, y and z coordinates.
     @param x The value defining the Polytopes alignment along the x axis.
     @param y The value defining the Polytopes alignment along the y axis.
     @param z The value defining the Polytopes alignment along the z axis.
     */
    public init(x: MDWFloat, y: MDWFloat, z: MDWFloat) {
        
        self.init(x: x, y: [y, y, y, y], z: z)
    }
    
    /*!
     @method init:x:y:z
     @abstract Creates and initialises a Polytope with unit length at the specified x, y and z coordinates.
     @param x The value defining the Polytopes alignment along the x axis.
     @param y An array of Integer values defining the Polytopes alignment along the y axis.
     @param z The value defining the Polytopes alignment along the z axis.
     */
    public init(x: MDWFloat, y: [Int], z: MDWFloat) {
        
        self.init(x: x, y: [World.Y(y: y[0]), World.Y(y: y[1]), World.Y(y: y[2]), World.Y(y: y[3])], z: z)
    }
    
    /*!
     @method init:x:y:z
     @abstract Creates and initialises a Polytope with unit length at the specified x, y and z coordinates.
     @param x The value defining the Polytopes alignment along the x axis.
     @param y An array of Float values defining the Polytopes alignment along the y axis.
     @param z The value defining the Polytopes alignment along the z axis.
     */
    public init(x: MDWFloat, y: [MDWFloat], z: MDWFloat) {
        
        self.vertices = [SCNVector3(x: (x + World.UnitXZ), y:y[0], z: (z + World.UnitXZ)),
                         SCNVector3(x: (x + -World.UnitXZ), y: y[1], z: (z + World.UnitXZ)),
                         SCNVector3(x: (x + -World.UnitXZ), y: y[2], z: (z + -World.UnitXZ)),
                         SCNVector3(x: (x + World.UnitXZ), y: y[3], z: (z + -World.UnitXZ))]
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
    
    /*!
     @enum Elevation
     @abstract Defines the relative elevation of one Polytope to another along the y axis.
     */
    enum Elevation {
        
        case above
        case below
        case equal
        case intersecting
    }
    
    /*!
     @method elevation:referencing
     @abstract Determines the elevation of the Polytope in reference to another Polytope.
     @discussion Polytope elevation is determined by checking the y axis values of each Polytope.
     */
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
    
    /*!
     @method Project:project:against
     @abstract Combine the x and z components of one Polytope with the y components of another.
     @param project The Polytope to be projected along the x and z axis of the reference Polytope.
     @param against The reference Polytope whose x and z axis values should be referenced.
     */
    static func Project(project: Polytope, against: Polytope) -> Polytope {
        
        let v0 = SCNVector3(x: against.vertices[0].x, y: project.vertices[0].y, z: against.vertices[0].z)
        let v1 = SCNVector3(x: against.vertices[1].x, y: project.vertices[1].y, z: against.vertices[1].z)
        let v2 = SCNVector3(x: against.vertices[2].x, y: project.vertices[2].y, z: against.vertices[2].z)
        let v3 = SCNVector3(x: against.vertices[3].x, y: project.vertices[3].y, z: against.vertices[3].z)
        
        return Polytope(vertices: [ v0, v1, v2, v3 ])
    }
    
    /*!
     @method Invert:polytope:edge
     @abstract Invert the vertices of a Polytope along the specified edge.
     @param polytope The Polytope to be inverted.
     @param edge The edge along which the vertices should be inverted.
     */
    static func Invert(polytope: Polytope, edge: GridEdge) -> Polytope {
        
        let v0 = polytope.vertices[0]
        let v1 = polytope.vertices[1]
        let v2 = polytope.vertices[2]
        let v3 = polytope.vertices[3]
        
        switch edge {
            
            case .north,
                 .south:
                
            return Polytope(vertices: [v3, v2, v1, v0])
            
            case .east,
                 .west:
                
            return Polytope(vertices: [v1, v0, v3, v2])
        }
    }
}
