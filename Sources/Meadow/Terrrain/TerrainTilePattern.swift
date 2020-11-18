//
//  TerrainTilePattern.swift
//
//  Created by Zack Brown on 09/11/2020.
//

struct TerrainTilePattern: Codable {
    
    var north: TerrainTileType
    var east: TerrainTileType
    var south: TerrainTileType
    var west: TerrainTileType
    
    var northWest: TerrainTileType
    var northEast: TerrainTileType
    var southEast: TerrainTileType
    var southWest: TerrainTileType
}

extension TerrainTilePattern {
    
    func rule(for cardinal: Cardinal) -> TerrainTileRule {
        
        switch cardinal {
        
        case .north: return TerrainTileRule(left: northWest, center: north, right: northEast)
        case .east: return TerrainTileRule(left: northEast, center: east, right: southEast)
        case .south: return TerrainTileRule(left: southEast, center: south, right: southWest)
        case .west: return TerrainTileRule(left: southWest, center: west, right: northWest)
        }
    }
}
