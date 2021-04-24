//
//  Surface.swift
//
//  Created by Zack Brown on 23/12/2020.
//

import SceneKit

public class Surface: Grid<SurfaceChunk, SurfaceTile> {
    
    lazy var tilemap: SurfaceTilemap = {
        
        guard let tilemap = try? SurfaceTilemap() else { fatalError("Error loading surface tilemap") }
        
        return tilemap
    }()
    
    lazy var program: SCNProgram? = {
        
        guard let library = scene?.library else { return nil }
        
        return SCNProgram(name: .surface, library: library)
    }()
    
    public override var category: Int { SceneGraphCategory.surface.rawValue }
}
