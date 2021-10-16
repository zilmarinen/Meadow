//
//  Buildings.swift
//
//  Created by Zack Brown on 27/03/2021.
//

import SceneKit

public class Buildings: PropGrid<BuildingChunk> {
    
    public override var category: SceneGraphCategory { .buildings }
    
    public lazy var program: SCNProgram? = {
        
        guard let library = scene?.library else { return nil }
        
        return SCNProgram(name: .building, library: library)
    }()
    
    var props: [Prop] { Array(Set(chunks.compactMap { $0.prop })) }
}
