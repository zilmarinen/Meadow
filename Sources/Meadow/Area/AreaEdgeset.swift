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

struct AreaEdgeset {
    
    enum Constants {
        
        static let edgesetIdentifier = "Area_Edgeset"
        static let edgemapIdentifier = "Area_Edgemap"
    }
    
    let image: MDWImage
    let edges: [AreaEdgesetEdge]
    
    init?(season: Season) throws {
        
        guard let tileset = Bundle.module.image(forResource: "\(season.description)_\(Constants.edgesetIdentifier)"), let json = NSDataAsset(name: "\(season.description)_\(Constants.edgemapIdentifier)", bundle: .module) else { return nil }

        let decoder = JSONDecoder()
        
        image = tileset
        edges = try decoder.decode([AreaEdgesetEdge].self, from: json.data)
    }
}

extension AreaEdgeset {
    
    func edges(with tileType: AreaTileType) -> [AreaEdgesetEdge] {
        
        return edges.filter { $0.tileType == tileType }
    }
}
