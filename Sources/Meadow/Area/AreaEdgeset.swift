//
//  AreaEdgeset.swift
//
//  Created by Zack Brown on 08/12/2020.
//

import Foundation

#if os(macOS)

    import AppKit

#else

    import UIKit

#endif

struct AreaEdgeset: Edgeset {
    
    enum Constants {
        
        static let edgesetIdentifier = "Area_Edgeset"
        static let edgemapIdentifier = "Area_Edgemap"
    }
    
    let image: MDWImage
    let edges: [AreaEdgesetEdge]
    
    init?() throws {
        
        guard let tileset = AreaEdgeset.edgeset(named: Constants.edgesetIdentifier),
              let tilemap = AreaEdgeset.edgemap(named: Constants.edgemapIdentifier) else { return nil }
        
        let decoder = JSONDecoder()
        
        image = tileset
        edges = try decoder.decode([AreaEdgesetEdge].self, from: tilemap.data)
    }
}

extension AreaEdgeset {
    
    func edges(with tileType: AreaTileType) -> [AreaEdgesetEdge] {
        
        return edges.filter { $0.tileType == tileType }
    }
}
