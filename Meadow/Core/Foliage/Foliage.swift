//
//  Foliage.swift
//  Meadow
//
//  Created by Zack Brown on 01/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation

public class Foliage: Grid<FoliageChunk, FoliageTile, FoliageNode>, GridIntermediateLoader {
    
    public typealias IntermediateType = FoliageNodeIntermediate
}

extension Foliage {
    
    public func load(nodes: [FoliageNodeIntermediate]) {
        
        //
    }
}

extension Foliage {
    
    public func add(node coordinate: Coordinate) -> FoliageNode? {
        
        guard let node = add(node: FoliageTile.fixedVolume(coordinate)) else { return nil }
        
        GridEdge.Edges.forEach { edge in
            
            if let tile = find(tile: coordinate + GridEdge.extent(edge: edge)) {
                
                for index in 0..<tile.totalChildren {
                    
                    if let neighbour = tile.child(at: index) as? FoliageNode, (neighbour.volume.coordinate.y >= coordinate.y - 1 && neighbour.volume.coordinate.y <= coordinate.y + 1) {
                        
                        node.add(neighbour: neighbour, edge: edge)
                    }
                }
            }
        }
        
        return node
    }
}
