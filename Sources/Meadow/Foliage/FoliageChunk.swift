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
    
    public override var category: SceneGraphCategory { .foliageChunk }
    
    public override var prop: Model {
        
        guard let model = scene?.props.prop(foliage: foliageType) else { fatalError("Error loading prop model \(foliageType)") }
        
        return model
    }
    
    public override var program: SCNProgram? { map?.foliage.program }
    
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
    
    public override func clean() -> Bool {
        
        guard isDirty else { return false }
        
        let rotation = Rotation(yaw: Angle(radians: (Double.pi / 2.0) * Double(direction.edge)))
        
        self.geometry = SCNGeometry(prop.mesh.rotated(by: rotation))
        
        return super.clean()
    }
}
