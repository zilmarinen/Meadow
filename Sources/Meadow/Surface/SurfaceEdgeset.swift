//
//  SurfaceEdgeset.swift
//
//  Created by Zack Brown on 26/11/2020.
//

import Foundation

#if os(macOS)

    import AppKit

#else

    import UIKit

#endif

struct SurfaceEdgeset: Edgeset {
    
    enum Constants {
        
        static let edgesetIdentifier = "Surface_Edgeset"
        static let edgemapIdentifier = "Surface_Edgemap"
    }
    
    let image: MDWImage
    let edges: [SurfaceEdgesetEdge]
    
    init?(season: Season) throws {
        
        guard let tileset = SurfaceEdgeset.edgeset(named: "\(season.description)_\(Constants.edgesetIdentifier)"),
              let tilemap = SurfaceEdgeset.edgemap(named: "\(season.description)_\(Constants.edgemapIdentifier)") else { return nil }
        
        let decoder = JSONDecoder()
        
        image = tileset
        edges = try decoder.decode([SurfaceEdgesetEdge].self, from: tilemap.data)
    }
}

extension SurfaceEdgeset {
    
    func edges(with tileType: SurfaceTileType) -> [SurfaceEdgesetEdge] {
        
        return edges.filter { $0.tileType == tileType }
    }
}
