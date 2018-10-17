//
//  SCNQuaternion.swift
//  Meadow
//
//  Created by Zack Brown on 08/06/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit
import GLKit

extension SCNQuaternion {
    
    public static func *(lhs: SCNQuaternion, rhs: SCNQuaternion) -> SCNQuaternion {
        
        let q0 = GLKQuaternionMake(Float(lhs.x), Float(lhs.y), Float(lhs.z), Float(lhs.w))
        let q1 = GLKQuaternionMake(Float(rhs.x), Float(rhs.y), Float(rhs.z), Float(rhs.w))
        
        let m = GLKQuaternionMultiply(q0, q1)
        
        return SCNQuaternion(x: MDWFloat(m.x), y: MDWFloat(m.y), z: MDWFloat(m.z), w: MDWFloat(m.w))
    }
    
    public static func *(lhs: SCNQuaternion, rhs: SCNVector3) -> SCNVector3 {
        
        let q = GLKQuaternionMake(Float(lhs.x), Float(lhs.y), Float(lhs.z), Float(lhs.w))
        
        let v = GLKVector3Make(Float(rhs.x), Float(rhs.y), Float(rhs.z))
        
        let r = GLKQuaternionRotateVector3(q, v)
        
        return SCNVector3(x: MDWFloat(r.x), y: MDWFloat(r.y), z: MDWFloat(r.z))
    }

    public static func normalise(quaternion: SCNQuaternion) -> SCNQuaternion {
        
        let q = GLKQuaternionMake(Float(quaternion.x), Float(quaternion.y), Float(quaternion.z), Float(quaternion.w))
        
        let n = GLKQuaternionNormalize(q)
        
        return SCNQuaternion(x: MDWFloat(n.x), y: MDWFloat(n.y), z: MDWFloat(n.z), w: MDWFloat(n.w))
    }

    public static func conjugate(quaternion: SCNQuaternion) -> SCNQuaternion {
        
        let q = GLKQuaternionMake(Float(quaternion.x), Float(quaternion.y), Float(quaternion.z), Float(quaternion.w))
        
        let c = GLKQuaternionConjugate(q)
        
        return SCNQuaternion(x: MDWFloat(c.x), y: MDWFloat(c.y), z: MDWFloat(c.z), w: MDWFloat(c.w))
    }

    public static func invert(quaternion: SCNQuaternion) -> SCNQuaternion {
        
        let q = GLKQuaternionMake(Float(quaternion.x), Float(quaternion.y), Float(quaternion.z), Float(quaternion.w))
        
        let i = GLKQuaternionInvert(q)
        
        return SCNQuaternion(x: MDWFloat(i.x), y: MDWFloat(i.y), z: MDWFloat(i.z), w: MDWFloat(i.w))
    }

    public static func focus(vector: SCNVector3, focus: SCNVector3, up: SCNVector3) -> SCNQuaternion {
        
        let worldUp = SCNVector3.normalise(vector: up)
        
        let forward = SCNVector3.normalise(vector: vector - focus)
        
        let right = SCNVector3.normalise(vector: SCNVector3.cross(lhs: worldUp, rhs: forward))
        
        let localUp = SCNVector3.normalise(vector: SCNVector3.cross(lhs: forward, rhs: right))
        
        let m = GLKMatrix4Make(Float(right.x), Float(right.y), Float(right.z), 0.0,
                               Float(localUp.x), Float(localUp.y), Float(localUp.z), 0.0,
                               Float(forward.x), Float(forward.y), Float(forward.z), 0.0,
                               Float(vector.x), Float(vector.y), Float(vector.z), 1.0)
        
        let q = GLKQuaternionMakeWithMatrix4(m)
        
        return SCNQuaternion(x: MDWFloat(q.x), y: MDWFloat(q.y), z: MDWFloat(q.z), w: MDWFloat(q.w))
    }

    public static func slerp(from: SCNQuaternion, to: SCNQuaternion, factor: MDWFloat) -> SCNQuaternion {
        
        let q0 = GLKQuaternionMake(Float(from.x), Float(from.y), Float(from.z), Float(from.w))
        let q1 = GLKQuaternionMake(Float(to.x), Float(to.y), Float(to.z), Float(to.w))
        
        let s = GLKQuaternionSlerp(q0, q1, Float(factor))
        
        return SCNQuaternion(x: MDWFloat(s.x), y: MDWFloat(s.y), z: MDWFloat(s.z), w: MDWFloat(s.w))
    }
}
