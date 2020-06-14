//
//  WaterChunk.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

public class WaterChunk: Chunk<WaterTile<WaterEdge>> {
    
    public override var category: SceneGraphNodeCategory { return .water }
    
    var shader: ShaderProgram {
        
        let program = ShaderProgram(named: "water")
        
        program.library = Stage.shaderLibrary
        
        return program
    }
    
    var uniform: ShaderUniform? { return nil }
}
