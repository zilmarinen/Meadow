//
//  TerrainResolver.swift
//  Meadow
//
//  Created by Zack Brown on 02/08/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

class TerrainResolver: GridResolver {
    
    var volumes: Set<Volume> = []
    
    let terrain: Terrain
    
    let areas: Area
    let footpaths: Footpath
    
    init(terrain: Terrain, areas: Area, footpaths: Footpath) {
        
        self.terrain = terrain
        
        self.areas = areas
        self.footpaths = footpaths
    }
}

extension TerrainResolver {
    
    func clean(volume: Volume) {
        
        guard let terrainNode = terrain.find(node: volume.coordinate) else { return }
        
        //
    }
}
