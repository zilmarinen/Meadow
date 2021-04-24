//
//  Water.swift
//
//  Created by Zack Brown on 26/03/2021.
//

import SceneKit

public class Water: Grid<WaterChunk, WaterTile> {
    
    lazy var program: SCNProgram? = {
        
        guard let library = scene?.library else { return nil }
        
        let program = SCNProgram(name: .water, library: library)
        
        program.isOpaque = false
        
        return program
    }()
    
    public override var category: Int { SceneGraphCategory.surface.rawValue }
}
