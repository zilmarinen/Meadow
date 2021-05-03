//
//  FoliageChunk.swift
//
//  Created by Zack Brown on 27/03/2021.
//

import Foundation
import SceneKit

class FoliageChunk: FootprintChunk {
    
    private enum CodingKeys: String, CodingKey {
        
        case foliageType = "t"
    }
    
    override var program: SCNProgram? { scene?.meadow.foliage.program }
    
    override var textures: [Texture]? {
        
        guard let texture = foliageType.texture else { return nil }
        
        return [texture]
    }
    
    let foliageType: FoliageType
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        foliageType = try container.decode(FoliageType.self, forKey: .foliageType)
        
        try super.init(from: decoder)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(foliageType, forKey: .foliageType)
    }
    
    override func clean() -> Bool {
        
        guard isDirty else { return false }
        
        position = SCNVector3(vector: coordinate.world)
        
        if let mesh = scene?.props.prop(foliage: foliageType).mesh {
         
            self.geometry = SCNGeometry(mesh: mesh)
            self.geometry?.program = program
        }
        
        if let uniforms = uniforms {
            
            self.geometry?.set(uniforms: uniforms)
        }
        
        if let textures = textures {
            
            self.geometry?.set(textures: textures)
        }
        
        isDirty = false
        
        return true
    }
}
