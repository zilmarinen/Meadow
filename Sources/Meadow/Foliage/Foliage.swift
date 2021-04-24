//
//  Foliage.swift
//
//  Created by Zack Brown on 27/03/2021.
//

import SceneKit

class Foliage: NonUniformGrid<FoliageChunk> {
    
    lazy var program: SCNProgram? = {
        
        guard let library = scene?.library else { return nil }
        
        return SCNProgram(name: .foliage, library: library)
    }()
}
