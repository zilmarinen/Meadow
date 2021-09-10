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
    
    public override var prop: Model {
        
        guard let model = scene?.props.prop(building: buildingType) else { fatalError("Error loading prop model \(buildingType)") }
        
        return model
    }
    
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
    
    public override func clean() -> Bool {
        
        guard isDirty else { return false }
        
        let rotation = Rotation(yaw: Angle(radians: (Double.pi / 2.0) * Double(direction.edge)))
        
        geometry = SCNGeometry(prop.mesh.rotated(by: rotation))
        
        return super.clean()
    }
}
