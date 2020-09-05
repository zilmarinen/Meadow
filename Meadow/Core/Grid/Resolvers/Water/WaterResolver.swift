//
//  WaterResolver.swift
//  Meadow
//
//  Created by Zack Brown on 07/06/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

class WaterResolver: GridResolver {
    
    var identifiers: [Int] = []
    
    let terrain: Terrain
    let water: Water
    
    init(terrain: Terrain, water: Water) {
       
        self.terrain = terrain
        self.water = water
    }
    
    func resolve(identifier: Int) {
        
        guard let terrainTile = terrain.find(tile: identifier), let waterTile = water.find(tile: identifier) else {
            
            water.remove(tile: identifier)
            
            return
        }
        
        waterTile.edges.forEach { (identifier, waterEdge) in
            
            guard let terrainEdge = terrainTile.find(edge: identifier), let terrainCorners = terrainEdge.topLayer?.corners, let waterCorners = waterEdge.topLayer?.corners else {
                
                waterTile.remove(edge: identifier)
                
                return
            }
            
            waterEdge.terrainCorners = terrainCorners
            waterEdge.isHidden = terrainCorners.base >= waterCorners.peak
        }
    }
}
