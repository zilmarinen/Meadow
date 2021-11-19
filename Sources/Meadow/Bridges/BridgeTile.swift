//
//  BridgeTile.swift
//
//  Created by Zack Brown on 15/08/2021.
//

import Euclid
import SceneKit

public class BridgeTile: Tile {
    
    private enum CodingKeys: String, CodingKey {
        
        case material = "m"
    }
    
    public override var category: SceneGraphCategory { .bridgeTile }
    
    let material: BridgeMaterial

    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        material = try container.decode(BridgeMaterial.self, forKey: .material)
        
        try super.init(from: decoder)
    }
}

extension BridgeTile {
    
    public static func == (lhs: BridgeTile, rhs: BridgeTile) -> Bool {
        
        return lhs.coordinate == rhs.coordinate && lhs.material == rhs.material
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
