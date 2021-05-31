//
//  SurfaceTileset.swift
//  
//  Created by Zack Brown on 13/11/2020.
//

import Foundation

public struct SurfaceTileset: Tileset {
    
    enum Constants {
        
        static let tilesetIdentifier = "Surface_Tileset"
        static let tilemapIdentifier = "Surface_Tilemap"
    }
    
    public let image: MDWImage
    public let tiles: [SurfaceTilesetTile]
    
    init?() throws {
        
        guard let tileset = SurfaceTileset.tileset(named: Constants.tilesetIdentifier),
              let tilemap = SurfaceTileset.tilemap(named: Constants.tilemapIdentifier) else { return nil }
        
        let decoder = JSONDecoder()
        
        image = tileset
        tiles = try decoder.decode([SurfaceTilesetTile].self, from: tilemap.data)
    }
}

extension SurfaceTileset {
    
    public func tiles(with pattern: Int) -> [SurfaceTilesetTile] {
        
        return tiles.filter { $0.pattern == pattern }
    }
}
