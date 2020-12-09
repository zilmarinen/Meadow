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

struct FootpathTileset {
    
    enum Constants {
        
        static let tilesetIdentifier = "Footpath_Tileset"
        static let tilemapIdentifier = "Footpath_Tilemap"
    }
    
    let image: MDWImage
    let tiles: [FootpathTilesetTile]
    
    init?(season: Season) throws {
        
        guard let tileset = Bundle.module.image(forResource: "\(season.description)_\(Constants.tilesetIdentifier)"), let json = NSDataAsset(name: "\(season.description)_\(Constants.tilemapIdentifier)", bundle: .module) else { return nil }
        
        let decoder = JSONDecoder()
        
        image = tileset
        tiles = try decoder.decode([FootpathTilesetTile].self, from: json.data)
    }
}

extension FootpathTileset {
    
    func tiles(with tileType: FootpathTileType) -> [FootpathTilesetTile] {
        
        return tiles.filter { $0.tileType == tileType }
    }
}
