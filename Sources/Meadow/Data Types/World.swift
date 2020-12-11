//
//  World.swift
//
//  Created by Zack Brown on 27/11/2020.
//

import Foundation

public struct World {
    
    let season: Season
    
    let tilemaps: Tilemaps
    
    public init(season: Season) {
        
        guard let tilemaps = try? Tilemaps(season: season) else { fatalError("Unable to load tilemaps for \(season)") }
        
        self.season = season
        self.tilemaps = tilemaps
    }
}
