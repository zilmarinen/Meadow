//
//  SCNVector3.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 30/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

extension SCNVector3 {
    
    public static var Up: SCNVector3 { return SCNVector3(x: 0.0, y: 1.0, z: 0.0) }
    static var Left: SCNVector3 { return SCNVector3(x: 1.0, y: 0.0, z: 0.0) }
    static var Right: SCNVector3 { return SCNVector3(x: -1.0, y: 0.0, z: 0.0) }
    static var Forward: SCNVector3 { return SCNVector3(x: 0.0, y: 0.0, z: 1.0) }
    static var Backward: SCNVector3 { return SCNVector3(x: 0.0, y: 0.0, z: -1.0) }
}

extension SCNVector3 {
    
    public static func +(lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
        
        let x = lhs.x + rhs.x
        let y = lhs.y + rhs.y
        let z = lhs.z + rhs.z
        
        return SCNVector3(x: x, y: y, z: z)
    }
    
    public static func +=(lhs: inout SCNVector3, rhs: SCNVector3) {
        
        lhs = lhs + rhs
    }
    
    public static func -(lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
        
        let x = lhs.x - rhs.x
        let y = lhs.y - rhs.y
        let z = lhs.z - rhs.z
        
        return SCNVector3(x: x, y: y, z: z)
    }
    
    public static func -=(lhs: inout SCNVector3, rhs: SCNVector3) {
        
        lhs = lhs - rhs
    }
    
    public static func *(lhs: SCNVector3, rhs: MDWFloat) -> SCNVector3 {
        
        return SCNVector3(x: lhs.x * rhs, y: lhs.y * rhs, z: lhs.z * rhs)
    }

    public static func Length(vector: SCNVector3) -> MDWFloat {
        
        let v = GLKVector3Make(Float(vector.x), Float(vector.y), Float(vector.z))
        
        return MDWFloat(GLKVector3Length(v))
    }

    public static func Normalise(vector: SCNVector3) -> SCNVector3 {
        
        let v = GLKVector3Make(Float(vector.x), Float(vector.y), Float(vector.z))
        
        let n = GLKVector3Normalize(v)
        
        return SCNVector3(x: MDWFloat(n.x), y: MDWFloat(n.y), z: MDWFloat(n.z))
    }

    public static func Negate(vector: SCNVector3) -> SCNVector3 {
        
        let v = GLKVector3Make(Float(vector.x), Float(vector.y), Float(vector.z))
        
        let n = GLKVector3Negate(v)
        
        return SCNVector3(x: MDWFloat(n.x), y: MDWFloat(n.y), z: MDWFloat(n.z))
    }

    public static func Dot(lhs: SCNVector3, rhs: SCNVector3) -> MDWFloat {
        
        let v0 = GLKVector3Make(Float(lhs.x), Float(lhs.y), Float(lhs.z))
        let v1 = GLKVector3Make(Float(rhs.x), Float(rhs.y), Float(rhs.z))
        
        return MDWFloat(GLKVector3DotProduct(v0, v1))
    }

    public static func Cross(lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
        
        let v0 = GLKVector3Make(Float(lhs.x), Float(lhs.y), Float(lhs.z))
        let v1 = GLKVector3Make(Float(rhs.x), Float(rhs.y), Float(rhs.z))
        
        let c = GLKVector3CrossProduct(v0, v1)
        
        return SCNVector3(x: MDWFloat(c.x), y: MDWFloat(c.y), z: MDWFloat(c.z))
    }

    public static func Lerp(from: SCNVector3, to: SCNVector3, factor: MDWFloat) -> SCNVector3 {
        
        let v0 = GLKVector3Make(Float(from.x), Float(from.y), Float(from.z))
        let v1 = GLKVector3Make(Float(to.x), Float(to.y), Float(to.z))
        
        let l = GLKVector3Lerp(v0, v1, Float(factor))
        
        return SCNVector3(x: MDWFloat(l.x), y: MDWFloat(l.y), z: MDWFloat(l.z))
    }
}
