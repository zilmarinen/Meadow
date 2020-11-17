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
