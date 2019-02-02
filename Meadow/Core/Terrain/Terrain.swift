//
//  Terrain.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation

public class Terrain: Grid<TerrainChunk, TerrainTile, TerrainNode<TerrainNodeEdge<TerrainEdgeLayer>>> {
    
    
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
    
    func add(node coordinate: Coordinate) -> TerrainNode<TerrainNodeEdge<TerrainEdgeLayer>>? {
        
        guard let node = add(node: TerrainTile.fixedVolume(coordinate)) else { return nil }
        
        GridEdge.Edges.forEach { edge in
            
            if let neighbour = find(node: coordinate + GridEdge.extent(edge: edge)) {
                
                node.add(neighbour: neighbour, edge: edge)
            }
        }
        
        return node
    }
    
    func find(edge coordinate: Coordinate, edge: GridEdge) -> TerrainNodeEdge<TerrainEdgeLayer>? {
        
        return find(node: coordinate)?.find(edge: edge)
    }
    
    @discardableResult
    func remove(layer: TerrainEdgeLayer) -> Bool {
        
        guard let node = find(node: layer.coordinate) else { return false }
        
        guard let edge = node.find(edge: layer.edge) else { return false }
        
        return edge.remove(layer: layer)
    }
}
