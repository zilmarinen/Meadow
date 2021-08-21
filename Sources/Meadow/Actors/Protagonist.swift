//
//  Hero.swift
//
//  Created by Zack Brown on 28/03/2021.
//

import SceneKit

public class Protagonist: Actor {
 
    @discardableResult public override func clean() -> Bool {
        
        guard super.clean() else { return false }
        
        self.geometry?.firstMaterial?.diffuse.contents = MDWColor.systemPink
        
        return true
    }
}
