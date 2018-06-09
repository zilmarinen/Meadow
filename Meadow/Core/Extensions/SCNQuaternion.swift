//
//  SCNQuaternion.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 08/06/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

extension SCNQuaternion {
    
    public static func *(lhs: SCNQuaternion, rhs: SCNQuaternion) -> SCNQuaternion {
        
        let w = (lhs.w * rhs.w - lhs.x * rhs.x - lhs.y * rhs.y - lhs.z * rhs.z)
        let x = (lhs.w * rhs.x + lhs.x * rhs.w + lhs.y * rhs.z - lhs.z * rhs.y)
        let y = (lhs.w * rhs.y - lhs.x * rhs.z + lhs.y * rhs.w + lhs.z * rhs.x)
        let z = (lhs.w * rhs.z + lhs.x * rhs.y - lhs.y * rhs.x + lhs.z * rhs.w)
        
        return SCNQuaternion(x: x, y: y, z: z, w: w)
    }
    
    /*!
     @method Negate:quaternion
     @abstract Returns a negated SCNQuaternion of the SCNQuaternion.
     @param vector The SCNQuaternion whose components should be negated and returned.
     */
    public static func Negate(quaternion: SCNQuaternion) -> SCNQuaternion {
        
        return SCNQuaternion(x: -quaternion.x, y: -quaternion.y, z: -quaternion.z, w: quaternion.w)
    }
}
