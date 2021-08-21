//
//  StairChunk.swift
//
//  Created by Zack Brown on 18/05/2021.
//

import Euclid
import SceneKit

public class StairChunk: FootprintChunk {
    
    private enum CodingKeys: String, CodingKey {
        
        case tileType = "t"
        case material = "m"
    }
    
    public override var category: Int { SceneGraphCategory.stairChunk.rawValue }
    
    public override var program: SCNProgram? { scene?.map.stairs.program }
    
    var tileType: StairType
    var material: StairMaterial
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        tileType = try container.decode(StairType.self, forKey: .tileType)
        material = try container.decode(StairMaterial.self, forKey: .material)
        
        try super.init(from: decoder)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(tileType, forKey: .tileType)
        try container.encode(material, forKey: .material)
    }
    
    public override func clean() -> Bool {
        
        guard super.clean(),
              let prop = scene?.props.prop(stairs: tileType, material: material) else { return false }
        
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

extension StairChunk: Traversable {
    
    var movementCost: Double { 1 }
    var walkable: Bool { true }
    
    func traversableNode(for coordinate: Coordinate) -> TraversableNode {
        
        var cardinals = [direction, direction.opposite]
        
        let (c0, c1) = direction.cardinals
        
        for cardinal in [c0, c1] {
            
            if footprint.intersects(coordinate: coordinate + cardinal.coordinate) {
                
                cardinals.append(cardinal)
            }
        }
        
        return TraversableNode(coordinate: Coordinate(x: coordinate.x, y: self.coordinate.y, z: coordinate.z), vector: coordinate.world, movementCost: movementCost, sloped: true, cardinals: cardinals)
    }
}
