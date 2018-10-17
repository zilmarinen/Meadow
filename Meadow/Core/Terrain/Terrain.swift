//
//  Terrain.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation

public class Terrain: Grid<TerrainChunk, TerrainTile, TerrainNode<TerrainLayer>> {
    
    
}

extension Terrain: SceneGraphIntermediate {
    
    public typealias IntermediateType = TerrainNodeIntermediate
    
    public func load(intermediates: [IntermediateType]) {
        
        intermediates.forEach { intermediate in
            
            if let node = add(node: intermediate.volume.coordinate) {
                
                node.load(intermediates: intermediate.children)
            }
        }
    }
}

extension Terrain {
    
    public func add(node coordinate: Coordinate) -> TerrainNode<TerrainLayer>? {
        
        guard let node = add(node: TerrainTile.fixedVolume(coordinate)) else { return nil }
        
        GridEdge.Edges.forEach { edge in
            
            if let neighbour = find(node: coordinate + GridEdge.extent(edge: edge)) {
                
                node.add(neighbour: neighbour, edge: edge)
            }
        }
        
        return node
    }
    
    public func add(layer coordinate: Coordinate, terrainType: TerrainType) -> TerrainLayer? {
        
        guard let node = find(node: coordinate) ?? add(node: coordinate) else { return nil }
        
        let layer = node.add(layer: terrainType)
        
        if layer != nil {
            
            becomeDirty()
        }
        
        return layer
    }
    
    public func remove(layer: TerrainLayer) -> Bool {
     
        guard let node = find(node: layer.coordinate) else { return false }
        
        if node.remove(layer: layer) {
            
            if node.totalChildren == 0 {
                
                let _ = remove(node: node)
                
                becomeDirty()
            }
            
            return true
        }
        
        return false
    }
}
