//
//  BridgeTile.swift
//
//  Created by Zack Brown on 15/08/2021.
//

import Euclid
import SceneKit

public class BridgeTile: Tile {
    
    private enum CodingKeys: String, CodingKey {
        
        case tileType = "t"
        case pattern = "p"
        case material = "m"
    }
    
    public override var category: Int { SceneGraphCategory.surfaceTile.rawValue }

    let tileType: BridgeTileType
    let pattern: WallPattern
    let material: BridgeMaterial

    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        tileType = try container.decode(BridgeTileType.self, forKey: .tileType)
        pattern = try container.decode(WallPattern.self, forKey: .pattern)
        material = try container.decode(BridgeMaterial.self, forKey: .material)
        
        try super.init(from: decoder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(tileType, forKey: .tileType)
        try container.encode(pattern, forKey: .pattern)
        try container.encode(material, forKey: .material)
    }
    
    override func render(position: Vector) -> [Euclid.Polygon] {
        
        guard let prop = scene?.props.prop(bridge: tileType, material: material, pattern: pattern) else { return [] }
        
        var invert = false
        
        switch tileType {
            
        case .corner(let lhs): invert = pattern.edges != 2 && lhs
        default: break
        }
        
        let rotation = Rotation(yaw: Angle(radians: (Double.pi / 2.0) * Double(pattern.rotation.rawValue + (invert ? 2 : 0))))
        
        let transform = Transform(offset: Vector(x: position.x, y: Double(coordinate.y) * World.Constants.slope, z: position.z), rotation: rotation)
        
        let mesh = prop.mesh.transformed(by: transform)
        
        return mesh.polygons
    }
}

extension BridgeTile {
    
    public static func == (lhs: BridgeTile, rhs: BridgeTile) -> Bool {
        
        return lhs.coordinate == rhs.coordinate && lhs.tileType == rhs.tileType && lhs.material == rhs.material
    }
}

extension BridgeTile: Traversable {
    
    var movementCost: Double { 1 }
    var walkable: Bool { true }
    
    func traversableNode(for coordinate: Coordinate) -> TraversableNode {
        
        //TODO: fix traversable bridge tiles
        
        return TraversableNode(coordinate: coordinate, vector: coordinate.world, movementCost: movementCost, sloped: false, cardinals: [.north])
    }
}
