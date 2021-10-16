//
//  Foliage.swift
//
//  Created by Zack Brown on 27/03/2021.
//

import SceneKit

public class Foliage: PropGrid<FoliageChunk> {
    
    public override var category: SceneGraphCategory { .foliage }
    
    public lazy var program: SCNProgram? = {
        
        guard let library = scene?.library else { return nil }
        
        return SCNProgram(name: .foliage, library: library)
    }()
    
    var props: [Prop] { Array(Set(chunks.compactMap { $0.prop })) }
}
