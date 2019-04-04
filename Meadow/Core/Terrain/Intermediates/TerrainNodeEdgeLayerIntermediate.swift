//
//  TerrainNodeEdgeLayerIntermediate.swift
//  Meadow
//
//  Created by Zack Brown on 25/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public struct TerrainNodeEdgeLayerIntermediate: Codable {
    
    let terrainType: Int
    
    let c0: TerrainNodeEdgeLayerCorner
    let c1: TerrainNodeEdgeLayerCorner
    let c2: TerrainNodeEdgeLayerCorner
}
