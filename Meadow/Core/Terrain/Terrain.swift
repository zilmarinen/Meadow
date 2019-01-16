//
//  Terrain.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation

public class Terrain: Grid<TerrainChunk, TerrainTile, TerrainNode<TerrainNodeEdge>> {
    
    
}

extension Terrain: SceneGraphIntermediate {
    
    public typealias IntermediateType = TerrainNodeIntermediate
    
    public func load(intermediates: [IntermediateType]) {
        
        intermediates.forEach { intermediate in
        
            intermediate.children.forEach { nodeEdgeIntermediate in
                
                nodeEdgeIntermediate.children.forEach { edgeLayerIntermediate in
                    
                    if let terrainType = TerrainType(rawValue: edgeLayerIntermediate.terrainType) {
                        
                        let _ = add(layer: intermediate.volume.coordinate, edge: nodeEdgeIntermediate.edge, terrainType: terrainType)
                    }
                }
            }
        }
    }
}

extension Terrain {
    
    public func add(layer coordinate: Coordinate, edge: GridEdge, terrainType: TerrainType) -> TerrainEdgeLayer? {
        
        let node = (find(node: coordinate) ?? add(node: coordinate))
        
        let nodeEdge = (node?.find(edge: edge) ?? node?.add(edge: edge))
        
        return nodeEdge?.add(layer: terrainType)
    }
    
    func add(node coordinate: Coordinate) -> TerrainNode<TerrainNodeEdge>? {
        
        guard let node = add(node: TerrainTile.fixedVolume(coordinate)) else { return nil }
        
        GridEdge.Edges.forEach { edge in
            
            if let neighbour = find(node: coordinate + GridEdge.extent(edge: edge)) {
                
                node.add(neighbour: neighbour, edge: edge)
            }
        }
        
        return node
    }
}
