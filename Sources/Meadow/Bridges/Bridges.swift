//
//  Bridges.swift
//
//  Created by Zack Brown on 08/05/2021.
//

import SceneKit

public class Bridges: FootprintGrid<BridgeChunk> {
    
    public override var category: Int { SceneGraphCategory.bridges.rawValue }
    
    public func find(bridge coordinate: Coordinate) -> BridgeChunk? {
        
        return chunks.first { $0.footprint.intersects(coordinate: coordinate) }
    }
}
