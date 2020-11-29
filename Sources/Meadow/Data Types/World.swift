//
//  World.swift
//
//  Created by Zack Brown on 27/11/2020.
//

import Foundation

public struct World {
    
    struct Tilemaps {
        
        let footpath: FootpathTileset
        let terrain: TerrainTilemap
        
        init?(season: Season) throws {
            
            guard let footpath = try FootpathTileset(season: season),
                  let terrain = try TerrainTilemap(season: season) else { return nil }
            
            self.footpath = footpath
            self.terrain = terrain
        }
    }
    
    let season: Season
    
    let tilemaps: Tilemaps
    
    init(season: Season) {
        
        guard let tilemaps = try? Tilemaps(season: season) else { fatalError("Unable to load tilemaps for \(season)") }
        
        self.season = season
        self.tilemaps = tilemaps
    }
}
