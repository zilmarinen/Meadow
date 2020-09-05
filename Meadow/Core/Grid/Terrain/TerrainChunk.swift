//
//  TerrainChunk.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import SceneKit

public class TerrainChunk: Chunk<TerrainTile>, Shadable {
    
    struct Uniform: ShaderUniform {
        
        var key: String { return "texture" }
        
        let texture: SCNMaterialProperty
    }
    
    public override var category: SceneGraphNodeCategory { return .terrain }
    
    var shader: ShaderProgram {
        
        let program = ShaderProgram(named: "terrain")
        
        program.library = Stage.shaderLibrary
        
        return program
    }
    
    var uniform: ShaderUniform? {
        
        guard let image = Image(named: Image.Name("noise")) else { return nil }
        
        return SCNMaterialProperty(contents: image)
    }
}
