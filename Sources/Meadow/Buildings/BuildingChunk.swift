//
//  BuildingChunk.swift
//
//  Created by Zack Brown on 27/03/2021.
//

import Euclid
import SceneKit

public class BuildingChunk: FootprintChunk {
    
    private enum CodingKeys: String, CodingKey {
        
        case buildingType = "t"
    }
    
    public override var category: SceneGraphCategory { .buildingChunk }
    
    public override var program: SCNProgram? { map?.buildings.program }
    
    let buildingType: BuildingType
    
    public override var textures: [Texture]? {
        
        guard let texture = buildingType.texture else { return nil }
        
        return [texture]
    }
    
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
    
    public override func clean() -> Bool {
        
        guard super.clean(),
              let prop = scene?.props.prop(building: buildingType) else { return false }
        
        self.geometry = SCNGeometry(prop.mesh.rotated(by: Rotation(yaw: Angle(degrees: 90.0 * Double(direction.rawValue)))))
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
