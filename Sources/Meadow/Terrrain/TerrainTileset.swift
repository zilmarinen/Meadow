//
//  TerrainTileset.swift
//  
//  Created by Zack Brown on 13/11/2020.
//

import Foundation

#if os(macOS)

    import AppKit

#else

    import UIKit

#endif

struct TerrainTileset: Tileset {
    
    enum Constants {
        
        static let tilesetIdentifier = "Terrain_Tileset"
        static let tilemapIdentifier = "Terrain_Tilemap"
    }
    
    let image: MDWImage
    let tiles: [TerrainTilesetTile]
    
    init?(season: Season) throws {
        
        guard let tileset = TerrainTileset.tileset(named: "\(season.description)_\(Constants.tilesetIdentifier)"),
              let tilemap = TerrainTileset.tilemap(named: "\(season.description)_\(Constants.tilemapIdentifier)") else { return nil }
        
        let decoder = JSONDecoder()
        
        image = tileset
        tiles = try decoder.decode([TerrainTilesetTile].self, from: tilemap.data)
    }
}

extension TerrainTileset {
    
    func tiles(with tileType: TerrainTileType) -> [TerrainTilesetTile] {
        
        return tiles.filter { $0.tileType == tileType }
    }
}
