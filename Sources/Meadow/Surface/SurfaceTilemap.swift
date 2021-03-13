//
//  SurfaceTilemap.swift
//
//  Created by Zack Brown on 26/11/2020.
//

struct SurfaceTilemap {
    
    let edgeset: SurfaceEdgeset
    let tileset: SurfaceTileset
    
    init?(season: Season) throws {
        
        guard let edgeset = try SurfaceEdgeset(season: season),
              let tileset = try SurfaceTileset(season: season) else { return nil }
        
        self.edgeset = edgeset
        self.tileset = tileset
    }
}
