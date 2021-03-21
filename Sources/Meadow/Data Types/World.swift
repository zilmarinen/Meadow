//
//  World.swift
//
//  Created by Zack Brown on 27/11/2020.
//

import Foundation

public struct World {
    
    public struct Constants {
        
        public static let floor = 0
        public static let ceiling = 10
        public static let slope = 0.25
        
        public static let chunkSize = 10
    }
    
    public let season: Season
    
    public let tilemaps: Tilemaps
    
    public init(season: Season) {
        
        guard let tilemaps = try? Tilemaps(season: season) else { fatalError("Unable to load tilemaps for \(season)") }
        
        self.season = season
        self.tilemaps = tilemaps
    }
}
