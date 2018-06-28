//
//  SCNVector3.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 30/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

extension SCNVector3 {
    
    /*!
     @var Up
     @abstract Returns a SCNVector3 with the x, y and z components set to 0, 1, 0.
     */
    public static var Up: SCNVector3 { return SCNVector3(x: 0.0, y: 1.0, z: 0.0) }
    
    /*!
     @property Left
     @abstract Returns a SCNVector3 with the x, y and z components set to 1, 0, 0.
     */
    static var Left: SCNVector3 { return SCNVector3(x: 1.0, y: 0.0, z: 0.0) }
    
    /*!
     @property Right
     @abstract Returns a SCNVector3 with the x, y and z components set to -1, 0, 0.
     */
    static var Right: SCNVector3 { return SCNVector3(x: -1.0, y: 0.0, z: 0.0) }
    
    /*!
     @property Forward
     @abstract Returns a SCNVector3 with the x, y and z components set to 0, 0, 1.
     */
    static var Forward: SCNVector3 { return SCNVector3(x: 0.0, y: 0.0, z: 1.0) }
    
    /*!
     @property Backward
     @abstract Returns a SCNVector3 with the x, y and z components set to 0, 0, -1.
     */
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
    
    /*!
     @method Length:vector
     @abstract Returns the length of the SCNVector3.
     @param vector The SCNVector3 whose length should be calculated and returned.
     */
    public static func Length(vector: SCNVector3) -> MDWFloat {
        
        let v = GLKVector3Make(Float(vector.x), Float(vector.y), Float(vector.z))
        
        return MDWFloat(GLKVector3Length(v))
    }
    
    /*!
     @method Normalise:vector
     @abstract Returns a normalised SCNVector3 of the SCNVector3.
     @param vector The SCNVector3 to be normalised.
     */
    public static func Normalise(vector: SCNVector3) -> SCNVector3 {
        
        let v = GLKVector3Make(Float(vector.x), Float(vector.y), Float(vector.z))
        
        let n = GLKVector3Normalize(v)
        
        return SCNVector3(x: MDWFloat(n.x), y: MDWFloat(n.y), z: MDWFloat(n.z))
    }
    
    /*!
     @method Negate:vector
     @abstract Returns a negated SCNVector3 of the SCNVector3.
     @param vector The SCNVector3 whose components should be negated and returned.
     */
    public static func Negate(vector: SCNVector3) -> SCNVector3 {
        
        let v = GLKVector3Make(Float(vector.x), Float(vector.y), Float(vector.z))
        
        let n = GLKVector3Negate(v)
        
        return SCNVector3(x: MDWFloat(n.x), y: MDWFloat(n.y), z: MDWFloat(n.z))
    }
    
    /*!
     @method Dot:lhs:rhs
     @abstract Calculates and returns the dot product of two SCNVector3.
     @property lhs A SCNVector3 to be used to calculate to dot product.
     @property rhs A SCNVector3 to be used to calculate to dot product.
     */
    public static func Dot(lhs: SCNVector3, rhs: SCNVector3) -> MDWFloat {
        
        let v0 = GLKVector3Make(Float(lhs.x), Float(lhs.y), Float(lhs.z))
        let v1 = GLKVector3Make(Float(rhs.x), Float(rhs.y), Float(rhs.z))
        
        return MDWFloat(GLKVector3DotProduct(v0, v1))
    }
    
    /*!
     @method Cross:lhs:rhs
     @abstract Calculates and returns the cross product of two SCNVector3.
     @property lhs A SCNVector3 to be used to calculate to cross product.
     @property rhs A SCNVector3 to be used to calculate to cross product.
     */
    public static func Cross(lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
        
        let v0 = GLKVector3Make(Float(lhs.x), Float(lhs.y), Float(lhs.z))
        let v1 = GLKVector3Make(Float(rhs.x), Float(rhs.y), Float(rhs.z))
        
        let c = GLKVector3CrossProduct(v0, v1)
        
        return SCNVector3(x: MDWFloat(c.x), y: MDWFloat(c.y), z: MDWFloat(c.z))
    }
    
    /*!
     @method Lerp:from:to:scalar
     @astract Linear interpolation of one vector toward another.
     @property from A SCNVector3 to interpolate from.
     @property from A SCNVector3 to interpolate toward.
     @property factor A value between 0 and 1 determining the amount of interpolation.
     */
    public static func Lerp(from: SCNVector3, to: SCNVector3, factor: MDWFloat) -> SCNVector3 {
        
        let v0 = GLKVector3Make(Float(from.x), Float(from.y), Float(from.z))
        let v1 = GLKVector3Make(Float(to.x), Float(to.y), Float(to.z))
        
        let l = GLKVector3Lerp(v0, v1, Float(factor))
        
        return SCNVector3(x: MDWFloat(l.x), y: MDWFloat(l.y), z: MDWFloat(l.z))
    }
}
