//
//  WaterResolver.swift
//  Meadow-iOS
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
            
            if let node = water.find(node: volume.coordinate) {
                
                //
            }
        }
    }
}

extension WaterResolver {
    
    
}
