//
//  SCNGeometry.swift
//  Meadow
//
//  Created by Zack Brown on 14/05/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import SceneKit

extension SCNGeometry {
    
    public func set(uniform: ShaderUniform) {
        
        if let uniform = uniform as? SCNMaterialProperty {
        
            setValue(uniform, forKey: uniform.key)
        }
        else {
        
            setValue(uniform.bytes, forKey: uniform.key)
        }
    }
}
