//
//  BuildingChunk.swift
//
//  Created by Zack Brown on 27/03/2021.
//

import Euclid
import SceneKit

public class BuildingChunk: PropChunk {
    
    private enum CodingKeys: String, CodingKey {
        
        case architecture = "a"
        case polyomino = "p"
    }
    
    public override var category: SceneGraphCategory { .buildingChunk }
    
    public override var prop: Prop { .building(architecture: architecture, polyomino: polyomino) }
    
    public override var program: SCNProgram? { map?.buildings.program }
    
    public override var textures: [Texture]? {
        
        guard let texture = scene?.atlas.buildings.texture(for: architecture) else { return nil }
        
        return [texture]
    }
    
    public let architecture: BuildingArchitecture
    public let polyomino: Polyomino
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        architecture = try container.decode(BuildingArchitecture.self, forKey: .architecture)
        polyomino = try container.decode(Polyomino.self, forKey: .polyomino)
        
        try super.init(from: decoder)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func clean() -> Bool {
        
        guard isDirty,
              let model = scene?.props.model(prop: prop) else { return false }
        
        let rotation = Rotation(yaw: Angle(radians: (Double.pi / 2.0) * Double(direction.edge)))
        
        geometry = SCNGeometry(model.mesh.rotated(by: rotation))
        
        return super.clean()
    }
}
