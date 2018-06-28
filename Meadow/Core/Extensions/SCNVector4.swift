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
     @method Length
     @abstract Returns the length of the SCNVector4.
     @param vector The SCNVector4 whose length should be calculated and returned.
     */
    public static func Length(vector: SCNVector4) -> MDWFloat {
        
        let v = GLKVector4Make(Float(vector.x), Float(vector.y), Float(vector.z), Float(vector.w))
        
        return MDWFloat(GLKVector4Length(v))
    }
    
    /*!
     @method Normalise:vector
     @abstract Returns a normalised SCNVector4 of the SCNVector4.
     @param vector The SCNVector4 to be normalised.
     */
    public static func Normalise(vector: SCNVector4) -> SCNVector4 {
        
        let v = GLKVector4Make(Float(vector.x), Float(vector.y), Float(vector.z), Float(vector.w))
        
        let n = GLKVector4Normalize(v)
        
        return SCNVector4(x: MDWFloat(n.x), y: MDWFloat(n.y), z: MDWFloat(n.z), w: MDWFloat(n.w))
    }
}
