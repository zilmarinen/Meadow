//
//  Stairs.swift
//  
//
//  Created by Zack Brown on 18/05/2021.
//

import SceneKit

public class Stairs: PropGrid<StairChunk> {
    
    public override var category: SceneGraphCategory { .stairs }
    
    public lazy var program: SCNProgram? = {
        
        guard let library = scene?.library else { return nil }
        
        return SCNProgram(name: .stairs, library: library)
    }()

    var props: [Prop] { Array(Set(chunks.compactMap { $0.prop })) }
}
