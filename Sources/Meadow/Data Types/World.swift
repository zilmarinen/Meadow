//
//  World.swift
//
//  Created by Zack Brown on 27/11/2020.
//

import Foundation

public struct World: Equatable {
    
    public struct Constants {
        
        public static let floor = 0
        public static let ceiling = 10
        static let slope = 0.25
        
        static let chunkSize = 5
    }
    
    public let season: Season
    
    let tilemaps: Tilemaps
    
    public init(season: Season) {
        
        guard let tilemaps = try? Tilemaps(season: season) else { fatalError("Unable to load tilemaps for \(season)") }
        
        self.season = season
        self.tilemaps = tilemaps
    }
}

extension World {
    
    public static func == (lhs: World, rhs: World) -> Bool {
        
        return lhs.season == rhs.season
    }
}
