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
    
    public override var category: SceneGraphCategory { .stairChunk }
    
    public override var prop: Model {
        
        guard let model = scene?.props.prop(stairs: tileType, material: material) else { fatalError("Error loading prop model \(tileType) -> \(material)") }
        
        return model
    }
    
    public override var program: SCNProgram? { map?.stairs.program }
    
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
    
    public override func clean() -> Bool {
        
        guard isDirty else { return false }
        
        let rotation = Rotation(yaw: Angle(radians: (Double.pi / 2.0) * Double(direction.edge)))
        
        self.geometry = SCNGeometry(prop.mesh.rotated(by: rotation))
        
        return super.clean()
    }
}

extension StairChunk: Traversable {
    
    var movementCost: Double { 1 }
    var walkable: Bool { true }
    
    func traversableNode(for coordinate: Coordinate) -> TraversableNode {
        
        var cardinals = [direction, direction.opposite]
        
        let (c0, c1) = direction.cardinals
        
        for cardinal in [c0, c1] {
            
            if prop.footprint.intersects(coordinate: coordinate + cardinal.coordinate) {
                
                cardinals.append(cardinal)
            }
        }
        
        return TraversableNode(coordinate: Coordinate(x: coordinate.x, y: self.coordinate.y, z: coordinate.z), vector: coordinate.world, movementCost: movementCost, sloped: true, cardinals: cardinals)
    }
}
