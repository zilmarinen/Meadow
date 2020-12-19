//
//  FootpathTileset.swift  
//
//  Created by Zack Brown on 27/11/2020.
//

import Foundation

#if os(macOS)

    import AppKit

#else

    import UIKit

#endif

struct FootpathTileset: Tileset {
    
    enum Constants {
        
        static let tilesetIdentifier = "Footpath_Tileset"
        static let tilemapIdentifier = "Footpath_Tilemap"
    }
    
    let image: MDWImage
    let tiles: [FootpathTilesetTile]
    
    init?() throws {
        
        guard let tileset = FootpathTileset.tileset(named: Constants.tilesetIdentifier),
              let tilemap = FootpathTileset.tilemap(named: Constants.tilemapIdentifier) else { return nil }
        
        let decoder = JSONDecoder()
        
        image = tileset
        tiles = try decoder.decode([FootpathTilesetTile].self, from: tilemap.data)
    }
}

extension FootpathTileset {
    
    func tiles(with tileType: FootpathTileType) -> [FootpathTilesetTile] {
        
        return tiles.filter { $0.tileType == tileType }
    }
}
