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
        
        let edges = GridEdge.Edges
        
        for edgeIndex in 0..<edges.count {
            
            let edge = edges[edgeIndex]
         
            guard let waterNodeEdge = node.find(edge: edge) else { continue }
            
            guard let terrainLayer = terrainNode.find(edge: edge)?.topLayer else {
                
                node.remove(edge: waterNodeEdge)
                
                continue
            }
            
            guard Axis.Y(y: terrainLayer.upperPolytope.base) < waterNodeEdge.waterLevel else {
                
                node.remove(edge: waterNodeEdge)
                
                continue
            }
            
            waterNodeEdge.terrainPolytope = terrainLayer.upperPolytope
            
            let oppositeEdge = GridEdge.opposite(edge: edge)
            let connectedEdges = GridEdge.edges(edge: edge)
            
            let neighbourWaterNode = node.find(neighbour: edge)?.node as? WaterNode
            let neighbourTerrainNode = terrainNode.find(neighbour: edge)?.node as? TerrainNode
            
            if neighbourWaterNode == nil, let neighbourTerrainLayer = neighbourTerrainNode?.find(edge: oppositeEdge)?.topLayer {
                
                let nodeEdge = water.add(edge: neighbourTerrainLayer.volume.coordinate, edge: oppositeEdge, waterType: waterNodeEdge.waterType)
                
                nodeEdge?.waterLevel = waterNodeEdge.waterLevel
                nodeEdge?.terrainPolytope = neighbourTerrainLayer.upperPolytope
            }
            
            [connectedEdges.e0, connectedEdges.e1].forEach { connectedEdge in
                
                let connectedWaterNodeEdge = node.find(edge: connectedEdge)
                let connectedTerrainEdgeLayer = terrainNode.find(edge: connectedEdge)?.topLayer
                
                if let connectedTerrainEdgeLayer = connectedTerrainEdgeLayer, connectedWaterNodeEdge == nil {
                    
                    if Axis.Y(y: connectedTerrainEdgeLayer.upperPolytope.base) < waterNodeEdge.waterLevel {
                        
                        let nodeEdge = node.add(edge: connectedEdge, waterType: waterNodeEdge.waterType)
                        
                        nodeEdge?.waterLevel = waterNodeEdge.waterLevel
                        nodeEdge?.terrainPolytope = connectedTerrainEdgeLayer.upperPolytope
                    }
                }
            }
        }
    }
}
