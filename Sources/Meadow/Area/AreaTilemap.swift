//
//  AreaTilemap.swift
//
//  Created by Zack Brown on 08/12/2020.
//

struct AreaTilemap {
    
    let edgeset: AreaEdgeset
    let tileset: AreaTileset
    
    init?(season: Season) throws {
        
        guard let edgeset = try AreaEdgeset(season: season), let tileset = try AreaTileset(season: season) else { return nil }
        
        self.edgeset = edgeset
        self.tileset = tileset
    }
}
