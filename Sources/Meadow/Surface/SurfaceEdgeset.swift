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

public struct SurfaceEdgeset: Edgeset {
    
    enum Constants {
        
        static let edgesetIdentifier = "Surface_Edgeset"
        static let edgemapIdentifier = "Surface_Edgemap"
    }
    
    public let image: MDWImage
    public let edges: [SurfaceEdgesetEdge]
    
    init?() throws {
        
        guard let tileset = SurfaceEdgeset.edgeset(named: Constants.edgesetIdentifier),
              let tilemap = SurfaceEdgeset.edgemap(named: Constants.edgemapIdentifier) else { return nil }
        
        let decoder = JSONDecoder()
        
        image = tileset
        edges = try decoder.decode([SurfaceEdgesetEdge].self, from: tilemap.data)
    }
}

extension SurfaceEdgeset {
    
    func edges(with pattern: Int) -> [SurfaceEdgesetEdge] {
        
        return edges.filter { $0.pattern == pattern }
    }
}
