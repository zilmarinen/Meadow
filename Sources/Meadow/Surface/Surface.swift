//
//  Surface.swift
//
//  Created by Zack Brown on 23/12/2020.
//

import SceneKit

public class Surface: Grid<SurfaceChunk, SurfaceTile> {
    
    lazy var program: SCNProgram? = {
        
        guard let library = scene?.library else { return nil }
        
        return SCNProgram(name: .surface, library: library)
    }()
    
    public override var category: SceneGraphCategory { .surface }
}
