//
//  TerrainEdgeset.swift
//
//  Created by Zack Brown on 26/11/2020.
//

import Foundation

#if os(macOS)

    import AppKit

#else

    import UIKit

#endif

struct TerrainEdgeset: Edgeset {
    
    enum Constants {
        
        static let edgesetIdentifier = "Terrain_Edgeset"
        static let edgemapIdentifier = "Terrain_Edgemap"
    }
    
    let image: MDWImage
    let edges: [TerrainEdgesetEdge]
    
    init?(season: Season) throws {
        
        guard let tileset = TerrainEdgeset.edgeset(named: "\(season.description)_\(Constants.edgesetIdentifier)"),
              let tilemap = TerrainEdgeset.edgemap(named: "\(season.description)_\(Constants.edgemapIdentifier)") else { return nil }
        
        let decoder = JSONDecoder()
        
        image = tileset
        edges = try decoder.decode([TerrainEdgesetEdge].self, from: tilemap.data)
    }
}

extension TerrainEdgeset {
    
    func edges(with tileType: TerrainTileType) -> [TerrainEdgesetEdge] {
        
        return edges.filter { $0.tileType == tileType }
    }
}
