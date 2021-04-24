//
//  BuildingChunk.swift
//
//  Created by Zack Brown on 27/03/2021.
//

import SceneKit

class BuildingChunk: NonUniformChunk {
    
    private enum CodingKeys: String, CodingKey {
        
        case buildingType = "t"
    }
    
    let buildingType: BuildingType
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        buildingType = try container.decode(BuildingType.self, forKey: .buildingType)
        
        try super.init(from: decoder)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(buildingType, forKey: .buildingType)
    }
    
    override func clean() -> Bool {
        
        guard isDirty else { return false }
        
        position = SCNVector3(x: CGFloat(footprint.coordinate.x), y: CGFloat(Double(footprint.coordinate.y) * World.Constants.slope), z: CGFloat(footprint.coordinate.z))
        
        if let mesh = buildingType.model?.mesh {
         
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
