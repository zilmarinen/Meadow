//
//  TerrainNodeEdgeIntermediate.swift
//  Meadow
//
//  Created by Zack Brown on 20/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public struct TerrainNodeEdgeIntermediate: Decodable {
    
    let edge: GridEdge
    
    let children: [TerrainEdgeLayerIntermediate]
}
