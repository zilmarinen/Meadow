//
//  TerrainLayerEdgeIntermediate.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 25/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public struct TerrainLayerEdgeIntermediate: Codable {
    
    let edge: GridEdge
    
    let terrainType: String
}

public struct TerrainLayerEdgesIntermediate: Codable {
    
    let north: TerrainLayerEdgeIntermediate
    let east: TerrainLayerEdgeIntermediate
    let south: TerrainLayerEdgeIntermediate
    let west: TerrainLayerEdgeIntermediate
}
