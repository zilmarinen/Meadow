//
//  Walls.swift
//
//  Created by Zack Brown on 09/08/2021.
//

import SceneKit

public class Walls: Grid<WallChunk, WallTile> {
    
    public lazy var program: SCNProgram? = {
        
        guard let library = scene?.library else { return nil }
        
        return SCNProgram(name: .walls, library: library)
    }()
    
    public override var category: SceneGraphCategory { .walls }
}
