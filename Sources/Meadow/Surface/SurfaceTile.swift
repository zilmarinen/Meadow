//
//  SurfaceTile.swift
//
//  Created by Zack Brown on 23/12/2020.
//

import Euclid
import SceneKit

public class SurfaceTile: Tile {
    
    private enum CodingKeys: String, CodingKey {
        
        case material = "m"
    }
    
    public override var category: SceneGraphCategory { .surfaceTile }

    let material: SurfaceMaterial

    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        material = try container.decode(SurfaceMaterial.self, forKey: .material)
        
        try super.init(from: decoder)
    }
}

extension SurfaceTile {
    
    public static func == (lhs: SurfaceTile, rhs: SurfaceTile) -> Bool {
        
        return lhs.coordinate == rhs.coordinate && lhs.material == rhs.material
    }
}

extension SurfaceTile: Traversable {
    
    var movementCost: Double { material.movementCost }
    var walkable: Bool { true }
    
    func traversableNode(for coordinate: Coordinate) -> TraversableNode {
        
        return TraversableNode(coordinate: self.coordinate, position: coordinate.position, movementCost: movementCost, sloped: false, cardinals: Cardinal.allCases)
    }
}
