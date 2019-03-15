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
    
    func clean(volume: Volume) {
     
        guard let foliageNode = foliage.find(node: volume.coordinate) else { return }
        
        guard let terrainNode = terrain.find(node: volume.coordinate) else {
            
            foliage.remove(node: foliageNode)
            
            return
        }
        
        //
    }
}
