//
//  Plane.swift
//  Meadow
//
//  Created by Zack Brown on 30/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public struct Plane {
    
    public enum Side {
        
        case exterior
        case interior
    }
    
    public let normal: SCNVector3

    let direction: MDWFloat
    
    init(v0: SCNVector3, v1: SCNVector3, v2: SCNVector3) {
        
        let ab = v1 - v0
        let ac = v2 - v0
        
        let cross = SCNVector3.cross(lhs: ab, rhs: ac)
        
        self.normal = SCNVector3.normalise(vector: cross)
        
        self.direction = -SCNVector3.dot(lhs: self.normal, rhs: v0)
    }
    
    public func side(vector: SCNVector3) -> Side {
        
        let dot = SCNVector3.dot(lhs: vector, rhs: normal)
        
        return dot > 0 ? .exterior : .interior
    }
}
