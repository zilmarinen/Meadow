//
//  SCNQuaternion.swift
//  Meadow-iOS
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
    
    /*!
     @method Normalise:quaternion
     @abstract Returns a normalised SCNQuaternion of the SCNQuaternion.
     @param vector The SCNQuaternion to be normalised.
     */
    public static func Normalise(quaternion: SCNQuaternion) -> SCNQuaternion {
        
        let q = GLKQuaternionMake(Float(quaternion.x), Float(quaternion.y), Float(quaternion.z), Float(quaternion.w))
        
        let n = GLKQuaternionNormalize(q)
        
        return SCNQuaternion(x: MDWFloat(n.x), y: MDWFloat(n.y), z: MDWFloat(n.z), w: MDWFloat(n.w))
    }
    
    /*!
     @method Conjugate:quaternion
     @abstract Returns the conjugate of a quaternion with the same scalar value, but the signs of the vector components are flipped.
     @param quaternion The SCNQuaternion whose components should be conjugated and returned.
     */
    public static func Conjugate(quaternion: SCNQuaternion) -> SCNQuaternion {
        
        let q = GLKQuaternionMake(Float(quaternion.x), Float(quaternion.y), Float(quaternion.z), Float(quaternion.w))
        
        let c = GLKQuaternionConjugate(q)
        
        return SCNQuaternion(x: MDWFloat(c.x), y: MDWFloat(c.y), z: MDWFloat(c.z), w: MDWFloat(c.w))
    }
    
    /*!
     @method Invert:quaternion
     @abstract Returns a negated SCNQuaternion of the SCNQuaternion.
     @param quaternion The SCNQuaternion whose components should be negated and returned.
     */
    public static func Invert(quaternion: SCNQuaternion) -> SCNQuaternion {
        
        let q = GLKQuaternionMake(Float(quaternion.x), Float(quaternion.y), Float(quaternion.z), Float(quaternion.w))
        
        let i = GLKQuaternionInvert(q)
        
        return SCNQuaternion(x: MDWFloat(i.x), y: MDWFloat(i.y), z: MDWFloat(i.z), w: MDWFloat(i.w))
    }
    
    /*!
     @method Focus:vector:focus:up
     @abstract Returns a SCNQuaternion rotated to face towards the specified focus point.
     @param vector The SCNVector3 representing the position from which to rotate to face towards the focus point.
     @param focus The SCNVector3 to rotate to face towards.
     @param up A SCNVector3 representing the direction of the world y axis.
     */
    public static func Focus(vector: SCNVector3, focus: SCNVector3, up: SCNVector3) -> SCNQuaternion {
        
        let worldUp = SCNVector3.Normalise(vector: up)
        
        let forward = SCNVector3.Normalise(vector: vector - focus)
        
        let right = SCNVector3.Normalise(vector: SCNVector3.Cross(lhs: worldUp, rhs: forward))
        
        let localUp = SCNVector3.Normalise(vector: SCNVector3.Cross(lhs: forward, rhs: right))
        
        let m = GLKMatrix4Make(Float(right.x), Float(right.y), Float(right.z), 0.0,
                               Float(localUp.x), Float(localUp.y), Float(localUp.z), 0.0,
                               Float(forward.x), Float(forward.y), Float(forward.z), 0.0,
                               Float(vector.x), Float(vector.y), Float(vector.z), 1.0)
        
        let q = GLKQuaternionMakeWithMatrix4(m)
        
        return SCNQuaternion(x: MDWFloat(q.x), y: MDWFloat(q.y), z: MDWFloat(q.z), w: MDWFloat(q.w))
    }
    
    /*!
     @method Slerp:from:to:scalar
     @astract Spherical linear interpolation of one quaternion toward another.
     @property from A SCNQuaternion to interpolate from.
     @property from A SCNQuaternion to interpolate toward.
     @property factor A value between 0 and 1 determining the amount of interpolation.
     */
    public static func Slerp(from: SCNQuaternion, to: SCNQuaternion, factor: MDWFloat) -> SCNQuaternion {
        
        let q0 = GLKQuaternionMake(Float(from.x), Float(from.y), Float(from.z), Float(from.w))
        let q1 = GLKQuaternionMake(Float(to.x), Float(to.y), Float(to.z), Float(to.w))
        
        let s = GLKQuaternionSlerp(q0, q1, Float(factor))
        
        return SCNQuaternion(x: MDWFloat(s.x), y: MDWFloat(s.y), z: MDWFloat(s.z), w: MDWFloat(s.w))
    }
}
