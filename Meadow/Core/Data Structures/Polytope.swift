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
    var peak: SCNFloat {
        
        return vertices.map{ $0.y }.max()!
    }
    
    /*!
     @property base
     @abstract The lowest y axis value of the Polytopes vertices.
     */
    var base: SCNFloat {
        
        return vertices.map{ $0.y }.min()!
    }
    
    /*!
     @method init:vertices
     @abstract Creates and initialises a Polytope with the specified vertices.
     @param vertices The vertices defining the Polytope.
     */
    init(vertices: [SCNVector3]) {
        
        self.vertices = vertices
    }
    
    /*!
     @method init:x:y:z
     @abstract Creates and initialises a Polytope with unit length at the specified x, y and z coordinates.
     @param x The value defining the Polytopes alignment along the x axis.
     @param y The value defining the Polytopes alignment along the y axis.
     @param z The value defining the Polytopes alignment along the z axis.
     */
    init(x: SCNFloat, y: SCNFloat, z: SCNFloat) {
        
        self.vertices = [SCNVector3(x: (x + -World.UnitXZ), y: y, z: (z + World.UnitXZ)),
                         SCNVector3(x: (x + World.UnitXZ), y: y, z: (z + World.UnitXZ)),
                         SCNVector3(x: (x + World.UnitXZ), y: y, z: (z + -World.UnitXZ)),
                         SCNVector3(x: (x + -World.UnitXZ), y: y, z: (z + -World.UnitXZ))]
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
     @property Unit
     @abstract Returns a Polytope with unit grid length defined by `World.UnitXZ`.
     */
    static var Unit: Polytope { return Polytope(x: 0.0, y: 0.0, z: 0.0) }
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
