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
    
    var peak: CGFloat {
        
        return vertices.map{ $0.y }.max()!
    }
    
    var base: CGFloat {
        
        return vertices.map{ $0.y }.min()!
    }
    
    init(vertices: [SCNVector3]) {
        
        self.vertices = vertices
    }
    
    init(x: CGFloat, y: CGFloat, z: CGFloat) {
        
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
    
    static var Unit: Polytope { return Polytope(x: 0.0, y: 0.0, z: 0.0) }
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
