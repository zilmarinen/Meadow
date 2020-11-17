//
//  TerrainTileset.swift
//  
//  Created by Zack Brown on 13/11/2020.
//

import Foundation

struct TerrainTileset {
    
    enum Constants {
        
        static let tilesetIdentifier = "_Tileset"
        static let tilemapIdentifier = "_Tilemap"
    }
    
    let image: MDWImage
    let tiles: [TerrainTilesetTile]
    
    init?(season: Season) throws {
        
        guard let tileset = Bundle.module.image(forResource: "\(season.description)_\(Constants.tilesetIdentifier)"), let url = Bundle.module.url(forResource: "\(season.description)_\(Constants.tilemapIdentifier)", withExtension: "json") else { return nil }
        
        let data = try Data(contentsOf: url)

        let decoder = JSONDecoder()

        image = tileset
        tiles = try decoder.decode([TerrainTilesetTile].self, from: data)
    }
}
