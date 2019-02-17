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
    
    func resolve() {
        
        while volumes.count > 0 {
            
            let volume = volumes.removeFirst()
            
            if let waterNode = water.find(node: volume.coordinate) {
                
                let terrainNode = terrain.find(node: volume.coordinate)
                
                clean(node: waterNode, terrainNode: terrainNode)
            }
        }
    }
}

extension WaterResolver {
    
    func clean(node: WaterNode<WaterNodeEdge>, terrainNode: TerrainNode<TerrainNodeEdge<TerrainEdgeLayer>>?) {
        
        guard let terrainNode = terrainNode else {
            
            water.remove(node: node)
            
            return
        }
        
        GridEdge.Edges.forEach { edge in
            
            if let waterNodeEdge = node.find(edge: edge) {
            
                let terrainEdgeLayer = terrainNode.find(edge: waterNodeEdge.edge)?.topLayer
                
                if terrainEdgeLayer == nil || Axis.Y(y: terrainEdgeLayer!.upperPolytope.base) >= waterNodeEdge.waterLevel {
                
                    water.remove(edge: waterNodeEdge)
                }
                else {
                    
                    waterNodeEdge.terrainPolytope = terrainEdgeLayer?.upperPolytope
                    
                    let (e0, e1) = GridEdge.edges(edge: waterNodeEdge.edge)
                    
                    [e0, e1].forEach { connectedEdge in
                        
                        let connectedWaterNodeEdge = node.find(edge: connectedEdge)
                        let connectedTerrainEdgeLayer = terrainNode.find(edge: connectedEdge)?.topLayer
                        
                        if let connectedTerrainEdgeLayer = connectedTerrainEdgeLayer, connectedWaterNodeEdge == nil {
                            
                            if Axis.Y(y: connectedTerrainEdgeLayer.upperPolytope.base) < waterNodeEdge.waterLevel {
                                
                                let nodeEdge = water.add(edge: node.volume.coordinate, edge: connectedEdge, waterType: waterNodeEdge.waterType)
                                
                                nodeEdge?.waterLevel = waterNodeEdge.waterLevel
                                nodeEdge?.terrainPolytope = connectedTerrainEdgeLayer.upperPolytope
                            }
                        }
                    }
                }
            }
        }
    }
}
