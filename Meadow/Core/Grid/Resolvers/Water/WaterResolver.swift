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
        
//        guard let terrainTile = terrain.find(tile: coordinate), let waterTile = water.find(tile: coordinate) else {
//            
//            water.remove(tile: coordinate)
//            
//            return
//        }
//        
//        waterTile.edges.forEach { (cardinal, waterEdge) in
//            
//            if let terrainEdge = terrainTile.find(edge: cardinal) {
//                
//                waterEdge.terrainCorners = terrainEdge.topLayer?.corners
//            }
//            else {
//                
//                waterTile.remove(edge: cardinal)
//            }
//        }
    }
}
