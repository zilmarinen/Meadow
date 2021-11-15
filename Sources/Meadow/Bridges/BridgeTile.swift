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
    
    public override var category: SceneGraphCategory { .bridgeTile }
    
    var prop: Prop { Prop.bridge(tileType: tileType, material: material, pattern: pattern) }

    let tileType: BridgeTileType
    let pattern: Cardinal
    let material: BridgeMaterial

    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        tileType = try container.decode(BridgeTileType.self, forKey: .tileType)
        pattern = try container.decode(Cardinal.self, forKey: .pattern)
        material = try container.decode(BridgeMaterial.self, forKey: .material)
        
        try super.init(from: decoder)
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
        
        return TraversableNode(coordinate: coordinate, position: coordinate.position, movementCost: movementCost, sloped: false, cardinals: [.north])
    }
}
