//
//  FoliageResolver.swift
//  Meadow
//
//  Created by Zack Brown on 05/09/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

class FoliageResolver: GridResolver {
    
    var volumes: Set<Volume> = []
    
    let foliage: Foliage
    
    let terrain: Terrain
    
    init(foliage: Foliage, terrain: Terrain) {
        
        self.foliage = foliage
        
        self.terrain = terrain
    }
}

extension FoliageResolver {
    
    func resolve() {
        
        while volumes.count > 0 {
            
            let volume = volumes.removeFirst()
            
            if let foliageNode = foliage.find(node: volume.coordinate) {
                
                let terrainNode = terrain.find(node: volume.coordinate)
                
                clean(node: foliageNode, terrainNode: terrainNode)
            }
        }
    }
}

extension FoliageResolver {
    
    func clean(node: FoliageNode, terrainNode: TerrainNode<TerrainNodeEdge>?) {
        
//        if let terrainNode = terrainNode, let upperPolytope = terrainNode.topLayer?.upperPolytope {
//
//            node.basePolytope = upperPolytope
//
//            return
//        }
        
        foliage.remove(node: node)
    }
}
