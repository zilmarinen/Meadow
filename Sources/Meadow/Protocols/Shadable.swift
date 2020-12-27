//
//  Shadable.swift
//
//  Created by Zack Brown on 23/12/2020.
//

import SceneKit

protocol Shadable {
    
    var program: SCNProgram? { get }
    
    var uniforms: [Uniform]? { get }
    
    var textures: [Texture]? { get }
}
