//
//  AreaTileset.swift
//
//  Created by Zack Brown on 08/12/2020.
//

import Foundation

#if os(macOS)

    import AppKit

#else

    import UIKit

#endif

struct AreaTileset {
    
    enum Constants {
        
        static let tilesetIdentifier = "Area_Tileset"
        static let tilemapIdentifier = "Area_Tilemap"
    }
    
    let image: MDWImage
    let tiles: [AreaTilesetTile]
    
    init?(season: Season) throws {
        
        guard let tileset = Bundle.module.image(forResource: "\(season.description)_\(Constants.tilesetIdentifier)"), let json = NSDataAsset(name: "\(season.description)_\(Constants.tilemapIdentifier)", bundle: .module) else { return nil }

        let decoder = JSONDecoder()
        
        image = tileset
        tiles = try decoder.decode([AreaTilesetTile].self, from: json.data)
    }
}

extension AreaTileset {
    
    func tiles(with tileType: AreaTileType) -> [AreaTilesetTile] {
        
        return tiles.filter { $0.tileType == tileType }
    }
}
