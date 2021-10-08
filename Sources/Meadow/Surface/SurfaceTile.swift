//
//  SurfaceTile.swift
//
//  Created by Zack Brown on 23/12/2020.
//

import Euclid
import SceneKit

public class SurfaceTile: Tile {
    
    private enum CodingKeys: String, CodingKey {
        
        case tileType = "tt"
        case material = "m"
        case overlay = "o"
    }
    
    public override var category: SceneGraphCategory { .surfaceTile }

    let tileType: SurfaceTileType
    let material: SurfaceMaterial
    let overlay: SurfaceOverlay?

    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        tileType = try container.decode(SurfaceTileType.self, forKey: .tileType)
        material = try container.decode(SurfaceMaterial.self, forKey: .material)
        overlay = try container.decodeIfPresent(SurfaceOverlay.self, forKey: .overlay)
        
        try super.init(from: decoder)
    }
}

extension SurfaceTile {
    
    public static func == (lhs: SurfaceTile, rhs: SurfaceTile) -> Bool {
        
        return lhs.coordinate == rhs.coordinate && lhs.tileType == rhs.tileType && lhs.material == rhs.material && lhs.overlay == rhs.overlay
    }
}

extension SurfaceTile: Traversable {
    
    var movementCost: Double { overlay?.movementCost ?? material.movementCost }
    var walkable: Bool {
        
        switch tileType {
        
        case .sloped:
            
//            let apex = volumes.apex()
//
//            guard let min = apex.min(),
//                  let max = apex.max() else { return false }
//
//            return max - min <= World.Constants.step
            return false
            
        case .terraced:
            
//            let apex = volumes.apex()
//
//            guard let min = apex.min(),
//                  let max = apex.max() else { return false }
//
//            return max == min
            return false
        }
    }
    
    func traversableNode(for coordinate: Coordinate) -> TraversableNode {
        
        return TraversableNode(coordinate: self.coordinate, vector: coordinate.world, movementCost: movementCost, sloped: tileType == .sloped, cardinals: Cardinal.allCases)
    }
}
