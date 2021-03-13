//
//  SurfaceTileset.swift
//  
//  Created by Zack Brown on 13/11/2020.
//

import Foundation

#if os(macOS)

    import AppKit

#else

    import UIKit

#endif

struct SurfaceTileset: Tileset {
    
    enum Constants {
        
        static let tilesetIdentifier = "Surface_Tileset"
        static let tilemapIdentifier = "Surface_Tilemap"
    }
    
    let image: MDWImage
    let tiles: [SurfaceTilesetTile]
    
    init?(season: Season) throws {
        
        guard let tileset = SurfaceTileset.tileset(named: "\(season.description)_\(Constants.tilesetIdentifier)"),
              let tilemap = SurfaceTileset.tilemap(named: "\(season.description)_\(Constants.tilemapIdentifier)") else { return nil }
        
        let decoder = JSONDecoder()
        
        image = tileset
        tiles = try decoder.decode([SurfaceTilesetTile].self, from: tilemap.data)
    }
}

extension SurfaceTileset {
    
    func tiles(with tileType: SurfaceTileType) -> [SurfaceTilesetTile] {
        
        return tiles.filter { $0.tileType == tileType }
    }
}
