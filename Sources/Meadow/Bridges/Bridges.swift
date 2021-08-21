//
//  Bridges.swift
//
//  Created by Zack Brown on 08/05/2021.
//

import SceneKit

public class Bridges: Grid<BridgeChunk, BridgeTile> {
    
    lazy var program: SCNProgram? = {
        
        guard let library = scene?.library else { return nil }
        
        return SCNProgram(name: .bridges, library: library)
    }()
    
    public override var category: Int { SceneGraphCategory.bridges.rawValue }
}
