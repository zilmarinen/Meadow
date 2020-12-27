//
//  Texture.swift
//
//  Created by Zack Brown on 24/12/2020.
//

import SceneKit

struct Texture {
    
    var key: String
    var value: SCNMaterialProperty
    
    init(key: String, image: MDWImage) {
        
        self.key = key
        self.value = SCNMaterialProperty(contents: image)
    }
}
