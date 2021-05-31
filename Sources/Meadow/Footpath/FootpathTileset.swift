//
//  FootpathTileset.swift
//
//  Created by Zack Brown on 25/03/2021.
//

import Foundation

public struct FootpathTileset: Tileset {
    
    enum Constants {
        
        static let tilesetIdentifier = "Footpath_Tileset"
        static let tilemapIdentifier = "Footpath_Tilemap"
    }
    
    public let image: MDWImage
    public let tiles: [FootpathTilesetTile]
    
    init?() throws {
        
        guard let tileset = FootpathTileset.tileset(named: Constants.tilesetIdentifier),
              let tilemap = FootpathTileset.tilemap(named: Constants.tilemapIdentifier) else { return nil }
        
        let decoder = JSONDecoder()
        
        image = tileset
        tiles = try decoder.decode([FootpathTilesetTile].self, from: tilemap.data)
    }
}

extension FootpathTileset {
    
    public func tiles(with pattern: Int, tileType: FootpathTileType) -> [FootpathTilesetTile] {
        
        return tiles.filter { $0.pattern == pattern && $0.tileType == tileType }
    }
}
