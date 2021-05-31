//
//  Stairs.swift
//  
//
//  Created by Zack Brown on 18/05/2021.
//

import SceneKit

public class Stairs: FootprintGrid<StairChunk> {
    
    public override var category: Int { SceneGraphCategory.stairs.rawValue }
    
    public func find(stairs coordinate: Coordinate) -> StairChunk? {
        
        return chunks.first { $0.footprint.intersects(coordinate: coordinate) }
    }
}
