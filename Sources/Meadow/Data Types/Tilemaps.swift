//
//  Tilemaps.swift
//
//  Created by Zack Brown on 01/12/2020.
//

import Foundation

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
