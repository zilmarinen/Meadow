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

struct TerrainTileset {
    
    enum Constants {
        
        static let tilesetIdentifier = "Tileset"
        static let tilemapIdentifier = "Tilemap"
    }
    
    let image: MDWImage
    let tiles: [TerrainTilesetTile]
    
    init?(season: Season) throws {
        
        guard let tileset = Bundle.module.image(forResource: "\(season.description)_\(Constants.tilesetIdentifier)"), let json = NSDataAsset(name: "\(season.description)_\(Constants.tilemapIdentifier)", bundle: .module) else { return nil }

        let decoder = JSONDecoder()
        
        image = tileset
        tiles = try decoder.decode([TerrainTilesetTile].self, from: json.data)
    }
}

extension TerrainTileset {
    
    func tiles(with tileType: TerrainTileType) -> [TerrainTilesetTile] {
        
        return tiles.filter { $0.tileType == tileType }
    }
}
