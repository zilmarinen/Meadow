//
//  SCNGeometry.swift
//
//  Created by Zack Brown on 03/11/2020.
//

import SceneKit

public extension SCNGeometry {
    
    func set(uniforms: [Uniform]) {
        
        for uniform in uniforms {
            
            setValue(uniform.value, forKey: uniform.key)
        }
    }
    
    func set(textures: [Texture]) {
        
        for texture in textures {
            
            setValue(texture.value, forKey: texture.key)
        }
    }
}
