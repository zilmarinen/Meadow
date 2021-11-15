//
//  StairChunk.swift
//
//  Created by Zack Brown on 18/05/2021.
//

import Euclid
import SceneKit

public class StairChunk: PropChunk {
    
    private enum CodingKeys: String, CodingKey {
        
        case stairType = "t"
        case material = "m"
    }
    
    public override var category: SceneGraphCategory { .stairChunk }
    
    public override var prop: Prop { .stairs(stairType: stairType, material: material) }
    
    public override var program: SCNProgram? { map?.stairs.program }
    
    var stairType: StairType
    var material: StairMaterial
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        stairType = try container.decode(StairType.self, forKey: .stairType)
        material = try container.decode(StairMaterial.self, forKey: .material)
        
        try super.init(from: decoder)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func clean() -> Bool {
        
        guard isDirty,
              let model = scene?.props.model(prop: prop) else { return false }
        
        let rotation = Rotation(yaw: Angle(radians: (Double.pi / 2.0) * Double(direction.edge)))
        
        self.geometry = SCNGeometry(model.mesh.rotated(by: rotation))
        
        return super.clean()
    }
}

extension StairChunk: Traversable {
    
    var movementCost: Double { 1 }
    var walkable: Bool { true }
    
    func traversableNode(for coordinate: Coordinate) -> TraversableNode {
        
        let model = scene?.props.model(prop: prop)
        
        var cardinals = [direction, direction.opposite]
        
        let (c0, c1) = direction.cardinals
        
        for cardinal in [c0, c1] {
            
            if model?.footprint.intersects(coordinate: coordinate + cardinal.coordinate) ?? false {
                
                cardinals.append(cardinal)
            }
        }
        
        return TraversableNode(coordinate: Coordinate(x: coordinate.x, y: self.coordinate.y, z: coordinate.z), position: coordinate.position, movementCost: movementCost, sloped: true, cardinals: cardinals)
    }
}
