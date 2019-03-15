//
//  WaterResolver.swift
//  Meadow
//
//  Created by Zack Brown on 06/08/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

class WaterResolver: GridResolver {
    
    var volumes: Set<Volume> = []
    
    let water: Water
    
    let terrain: Terrain
    
    init(water: Water, terrain: Terrain) {
        
        self.water = water
        
        self.terrain = terrain
    }
}

extension WaterResolver {
    
    func clean(volume: Volume) {
        
        guard let waterNode = water.find(node: volume.coordinate) else { return }
        
        guard let terrainNode = terrain.find(node: volume.coordinate), waterNode.totalChildren > 0 else {
            
            water.remove(node: waterNode)
            
            return
        }
        
        guard let waterTable = waterNode.waterTablePeak else { return }
        
        let edges = GridEdge.Edges
        
        for edgeIndex in 0..<edges.count {
            
            let edge = edges[edgeIndex]
            
            var waterNodeEdge = waterNode.find(edge: edge)
            
            let waterLevel = (waterNodeEdge?.waterLevel ?? waterTable.waterLevel)
            
            guard let terrainNodeEdge = terrainNode.find(edge: edge), let terrainEdgeLayer = terrainNodeEdge.topLayer,  terrainEdgeLayer.base < waterLevel else {
                
                if let waterNodeEdge = waterNodeEdge {
                    
                    waterNode.remove(edge: waterNodeEdge)
                }
                
                continue
            }
            
            if waterNodeEdge == nil && terrainEdgeLayer.base < waterLevel {
                
                waterNodeEdge = water.add(edge: waterNode.volume.coordinate, edge: edge, waterType: waterTable.waterType)
            }
            
            waterNodeEdge?.waterLevel = waterLevel
            waterNodeEdge?.terrainPolytope = terrainNodeEdge.upperPolytope
            
            if let waterNodeEdge = waterNodeEdge {
                
                let terrainNodeNeighbour = terrainNode.find(neighbour: edge)?.node as? TerrainNode
                let waterNodeNeighbour = waterNode.find(neighbour: edge)?.node as? WaterNode
                
                let oppositeEdge = GridEdge.opposite(edge: edge)
                
                let terrainNodeEdgeNeighbour = terrainNodeNeighbour?.find(edge: oppositeEdge)
                var waterNodeEdgeNeighbour = waterNodeNeighbour?.find(edge: oppositeEdge)
                
                if let terrainNodeNeighbour = terrainNodeNeighbour, let terrainEdgeLayerNeighbour = terrainNodeEdgeNeighbour?.topLayer, waterNodeEdgeNeighbour == nil && terrainEdgeLayerNeighbour.base < waterLevel {
                    
                    waterNodeEdgeNeighbour = water.add(edge: terrainNodeNeighbour.volume.coordinate, edge: oppositeEdge, waterType: waterNodeEdge.waterType)
                    
                    waterNodeEdgeNeighbour?.waterLevel = waterLevel
                }
            }
        }
    }
}
