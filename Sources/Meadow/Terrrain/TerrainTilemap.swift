//
//  TerrainTilemap.swift
//
//  Created by Zack Brown on 26/11/2020.
//

struct TerrainTilemap {
    
    let edgeset: TerrainEdgeset
    let tileset: TerrainTileset
    
    init?(season: Season) throws {
        
        guard let edgeset = try TerrainEdgeset(season: season),
              let tileset = try TerrainTileset(season: season) else { return nil }
        
        self.edgeset = edgeset
        self.tileset = tileset
    }
}
