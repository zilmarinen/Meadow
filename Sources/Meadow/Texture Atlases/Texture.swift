//
//  Texture.swift
//
//  Created by Zack Brown on 24/12/2020.
//

import Euclid
import SceneKit

public struct Texture: Equatable {
    
    public var key: String
    public var value: SCNMaterialProperty
    
    public init(key: String, image: MDWImage) {
        
        self.key = key
        self.value = SCNMaterialProperty(contents: image)
    }
}
