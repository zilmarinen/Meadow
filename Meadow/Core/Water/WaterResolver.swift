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
    
    func clean(node: WaterNode, terrainNode: TerrainNode<TerrainNodeEdge>?) {
        
//        if let terrainNode = terrainNode, let upperPolytope = terrainNode.topLayer?.upperPolytope {
//            
//            var waterLevel = node.waterLevel
//            
//            GridEdge.Edges.forEach { edge in
//                
//                if let neighbour = node.find(neighbour: edge)?.node as? WaterNode {
//                    
//                    waterLevel = max(waterLevel, neighbour.waterLevel)
//                }
//            }
//            
//            node.waterLevel = waterLevel
//            node.basePolytope = upperPolytope
//            
//            let elevation = node.upperPolytope.elevation(referencing: upperPolytope)
//            
//            if elevation == .above || elevation == .intersecting {
//                
//                GridEdge.Edges.forEach { edge in
//                    
//                    if let neighbour = node.find(neighbour: edge)?.node as? WaterNode {
//                        
//                        neighbour.waterLevel = waterLevel
//                    }
//                    else if terrainNode.find(neighbour: edge)?.node as? TerrainNode<TerrainNodeEdge> {
//                        
//                        water.add(node: node.volume.coordinate + GridEdge.extent(edge: edge))
//                    }
//                }
//                
//                return
//            }
//        }
        
        water.remove(node: node)
    }
}
