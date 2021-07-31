//
//  FoliageChunk.swift
//
//  Created by Zack Brown on 27/03/2021.
//

import Euclid
import Foundation
import SceneKit

public class FoliageChunk: FootprintChunk {
    
    private enum CodingKeys: String, CodingKey {
        
        case foliageType = "t"
    }
    
    public override var category: Int { SceneGraphCategory.foliageChunk.rawValue }
    
    public override var footprint: Footprint {
        
        guard let prop = scene?.props.prop(prop: foliageType) else { fatalError("Unable to load footprint for \(self)") }
        
        return prop.footprint
    }
    
    public override var program: SCNProgram? { scene?.meadow.foliage.program }
    
    public override var textures: [Texture]? {
        
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
    
    public override func clean() -> Bool {
        
        guard super.clean(),
              let prop = scene?.props.prop(prop: foliageType) else { return false }
        
        self.geometry = SCNGeometry(prop.mesh.translated(by: Vector(x: 0, y: Double(coordinate.y) * World.Constants.slope, z: 0)))
        self.geometry?.program = program
        
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
