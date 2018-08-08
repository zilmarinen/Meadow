//
//  SCNVector4.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 08/06/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

extension SCNVector4 {
    
    public static func length(vector: SCNVector4) -> MDWFloat {
        
        let v = GLKVector4Make(Float(vector.x), Float(vector.y), Float(vector.z), Float(vector.w))
        
        return MDWFloat(GLKVector4Length(v))
    }

    public static func normalise(vector: SCNVector4) -> SCNVector4 {
        
        let v = GLKVector4Make(Float(vector.x), Float(vector.y), Float(vector.z), Float(vector.w))
        
        let n = GLKVector4Normalize(v)
        
        return SCNVector4(x: MDWFloat(n.x), y: MDWFloat(n.y), z: MDWFloat(n.z), w: MDWFloat(n.w))
    }
}
