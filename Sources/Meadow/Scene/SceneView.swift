//
//  SceneView.swift
//
//  Created by Zack Brown on 08/01/2021.
//

import SceneKit

public class SceneView: SCNView {
    
    public var library: MTLLibrary?
    
    public override var scene: SCNScene? {
        
        willSet {
            
            guard let value = newValue as? Scene else { return }
            
            value.library = library
        }
    }
}
