//
//  SCNQuaternion.swift
//
//  Created by Zack Brown on 16/12/2020.
//

import GLKit
import SceneKit

extension SCNQuaternion {
    
    public init(quaternion: GLKQuaternion) {
        
        self.init(x: MDWFloat(quaternion.x), y: MDWFloat(quaternion.y), z: MDWFloat(quaternion.z), w: MDWFloat(quaternion.w))
    }
}
