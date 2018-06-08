//
//  SCNVector4.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 08/06/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

extension SCNVector4 {
    
    /*!
     @method magnitude
     @abstract Returns the length of the SCNVector4.
     @param vector The SCNVector4 whose magnitude should be calculated and returned.
     */
    public static func Magnitude(vector: SCNVector4) -> MDWFloat {
        
        let x = vector.x * vector.x
        let y = vector.y * vector.y
        let z = vector.z * vector.z
        let w = vector.w * vector.w
        
        let length = Float(x + y + z + w)
        
        return MDWFloat(sqrtf(length))
    }
    
    /*!
     @method Normalise:vector
     @abstract Returns a normalised SCNVector4 of the SCNVector4.
     @param vector The SCNVector4 to be normalised.
     */
    public static func Normalise(vector: SCNVector4) -> SCNVector4 {
        
        let length = SCNVector4.Magnitude(vector: vector)
        
        let x = vector.x / length
        let y = vector.y / length
        let z = vector.z / length
        let w = vector.w / length
        
        return SCNVector4(x: x, y: y, z: z, w: w)
    }
}
