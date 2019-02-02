//
//  Foliage.swift
//  Meadow
//
//  Created by Zack Brown on 01/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation

public class Foliage: Grid<FoliageChunk, FoliageTile, FoliageNode> {
    
}

extension Foliage: SceneGraphIntermediate {
    
    public typealias IntermediateType = FoliageNodeIntermediate
    
    public func load(intermediates: [IntermediateType]) {
        
        //
    }
}

extension Foliage {
    
    public func add(node coordinate: Coordinate) -> FoliageNode? {
        
        guard let node = add(node: FoliageTile.fixedVolume(coordinate)) else { return nil }
        
        node.foliageType = .bush
        
        GridEdge.Edges.forEach { edge in
            
            if let neighbour = find(node: coordinate + GridEdge.extent(edge: edge)) {
                
                node.add(neighbour: neighbour, edge: edge)
            }
        }
        
        return node
    }
}
