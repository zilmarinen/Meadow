//
//  Tilemaps.swift
//
//  Created by Zack Brown on 01/12/2020.
//

import Foundation

struct Tilemaps {
    
    let surface: SurfaceTilemap
    
    init?(season: Season) throws {
        
        guard let surface = try SurfaceTilemap(season: season) else { return nil }
        
        self.surface = surface
    }
}
