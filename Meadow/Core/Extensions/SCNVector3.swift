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
     @method Magnitude:vector
     @abstract Returns the length of the SCNVector3.
     @param vector The SCNVector3 whose magnitude should be calculated and returned.
     */
    public static func Magnitude(vector: SCNVector3) -> MDWFloat {
        
        let x = vector.x * vector.x
        let y = vector.y * vector.y
        let z = vector.z * vector.z
        
        let length = Float(x + y + z)
        
        return MDWFloat(sqrtf(length))
    }
    
    /*!
     @method Normalise:vector
     @abstract Returns a normalised SCNVector3 of the SCNVector3.
     @param vector The SCNVector3 to be normalised.
     */
    public static func Normalise(vector: SCNVector3) -> SCNVector3 {
        
        let length = SCNVector3.Magnitude(vector: vector)
        
        let x = vector.x / length
        let y = vector.y / length
        let z = vector.z / length
        
        return SCNVector3(x: x, y: y, z: z)
    }
    
    /*!
     @method Invert:vector
     @abstract Returns a negated SCNVector3 of the SCNVector3.
     @param vector The SCNVector3 whose components should be negated and returned.
     */
    public static func Invert(vector: SCNVector3) -> SCNVector3 {
        
        return SCNVector3(x: -vector.x, y: -vector.y, z: -vector.z)
    }
    
    /*!
     @method Dot:lhs:rhs
     @abstract Calculates and returns the dot product of two SCNVector3.
     @property lhs A SCNVector3 to be used to calculate to dot product.
     @property rhs A SCNVector3 to be used to calculate to dot product.
     */
    public static func Dot(lhs: SCNVector3, rhs: SCNVector3) -> MDWFloat {
        
        let x = (lhs.x * rhs.x)
        let y = (lhs.y * rhs.y)
        let z = (lhs.z * rhs.z)
        
        return MDWFloat(x + y + z)
    }
    
    /*!
     @method Cross:lhs:rhs
     @abstract Calculates and returns the cross product of two SCNVector3.
     @property lhs A SCNVector3 to be used to calculate to cross product.
     @property rhs A SCNVector3 to be used to calculate to cross product.
     */
    public static func Cross(lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
        
        let x = (lhs.y * rhs.z) - (lhs.z * rhs.y)
        let y = (lhs.z * rhs.x) - (lhs.x * rhs.z)
        let z = (lhs.x * rhs.y) - (lhs.y * rhs.x)
        
        return SCNVector3(x: x, y: y, z: z)
    }
    
    /*!
     @method Lerp:from:to:scalar
     @astract Linear interpolation of one vector toward another.
     @property from A SCNVector3 to interpolate from.
     @property from A SCNVector3 to interpolate toward.
     @property scalar A value between 0 and 1 determining the amount of interpolation.
     */
    public static func Lerp(from: SCNVector3, to: SCNVector3, scalar: MDWFloat) -> SCNVector3 {
        
        let d = min(max(scalar, 0), 1)
        
        let t = (1 - d)
        
        return SCNVector3(to.x * d + from.x * t, to.y * d + from.y * t, to.z * d + from.z * t)
    }
}
