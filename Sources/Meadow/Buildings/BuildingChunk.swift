//
//  BuildingChunk.swift
//
//  Created by Zack Brown on 27/03/2021.
//

import SceneKit

class BuildingChunk: NonUniformChunk {
    
    override func clean() -> Bool {
        
        guard super.clean() else { return false }
        
        self.geometry?.firstMaterial?.diffuse.contents = MDWColor.systemIndigo
        
        return true
    }
}
