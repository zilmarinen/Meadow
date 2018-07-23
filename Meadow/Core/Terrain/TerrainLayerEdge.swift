//
//  TerrainLayerEdge.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 23/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

extension TerrainLayer {
    
    public struct Edge: Codable, Hashable {
        
        let edge: GridEdge
        
        let terrainType: TerrainType
    }
    
    public struct Edges: Codable {
        
        var north: Edge
        var east: Edge
        var south: Edge
        var west: Edge
        
        init(terrainType: TerrainType) {
            
            self.north = Edge(edge: .north, terrainType: terrainType)
            self.east = Edge(edge: .east, terrainType: terrainType)
            self.south = Edge(edge: .south, terrainType: terrainType)
            self.west = Edge(edge: .west, terrainType: terrainType)
        }
    }
}
