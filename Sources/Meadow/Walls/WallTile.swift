//
//  WallTile.swift
//
//  Created by Zack Brown on 09/08/2021.
//

import Euclid
import SceneKit

public class WallTile: Tile {
    
    private enum CodingKeys: String, CodingKey {
        
        case tileType = "t"
        case pattern = "p"
        case material = "m"
        case external = "e"
    }
    
    public override var category: SceneGraphCategory { .wallTile }

    let tileType: WallTileType
    let material: WallTileMaterial
    let pattern: WallPattern
    let external: Bool

    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        tileType = try container.decode(WallTileType.self, forKey: .tileType)
        material = try container.decode(WallTileMaterial.self, forKey: .material)
        pattern = try container.decode(WallPattern.self, forKey: .pattern)
        external = try container.decode(Bool.self, forKey: .external)
        
        try super.init(from: decoder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(tileType, forKey: .tileType)
        try container.encode(material, forKey: .material)
        try container.encode(pattern, forKey: .pattern)
        try container.encode(external, forKey: .external)
    }
    
    override func render(position: Vector) -> [Euclid.Polygon] {
        
        guard let prop = scene?.props.prop(wall: tileType, material: material, pattern: pattern, external: external) else { return [] }
        
        let rotation = Rotation(yaw: Angle(radians: (Double.pi / 2.0) * Double(pattern.rotation.rawValue)))
        
        let transform = Transform(offset: Vector(x: position.x, y: Double(coordinate.y) * World.Constants.slope, z: position.z), rotation: rotation)
        
        let mesh = prop.mesh.transformed(by: transform)
        
        return mesh.polygons
    }
}

extension WallTile {
    
    public static func == (lhs: WallTile, rhs: WallTile) -> Bool {
        
        return lhs.coordinate == rhs.coordinate && lhs.tileType == rhs.tileType
    }
}
