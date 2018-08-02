//
//  Terrain.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation

public class Terrain: Grid<TerrainChunk, TerrainTile, TerrainNode<TerrainLayer>>, GridIntermediateLoader {
    
    public typealias IntermediateType = TerrainNodeIntermediate
}

extension Terrain {
    
    public func load(nodes: [TerrainNodeIntermediate]) {
        
        nodes.forEach { intermediate in
            
            if let node = add(node: intermediate.volume.coordinate) {
                
                node.load(nodes: intermediate.children)
            }
        }
    }
}

extension Terrain {
    
    public func add(node coordinate: Coordinate) -> TerrainNode<TerrainLayer>? {
        
        return add(node: TerrainTile.fixedVolume(coordinate))
    }
}
