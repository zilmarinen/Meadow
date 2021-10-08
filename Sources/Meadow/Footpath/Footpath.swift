//
//  Footpath.swift
//
//  Created by Zack Brown on 25/03/2021.
//

import SceneKit

public class Footpath: Grid<FootpathChunk, FootpathTile> {
    
    lazy var program: SCNProgram? = {
        
        guard let library = scene?.library else { return nil }
        
        return SCNProgram(name: .footpath, library: library)
    }()
    
    public override var category: SceneGraphCategory { .footpath }
}
