//
//  Bridges.swift
//
//  Created by Zack Brown on 08/05/2021.
//

import SceneKit

public class Bridges: Grid<BridgeChunk, BridgeTile> {
    
    public override var category: SceneGraphCategory { .bridges }
    
    lazy var program: SCNProgram? = {
        
        guard let library = scene?.library else { return nil }
        
        return SCNProgram(name: .bridges, library: library)
    }()
    
    var props: [Prop] { Array(Set(chunks.flatMap { $0.tiles.compactMap { $0.prop } })) }
}
