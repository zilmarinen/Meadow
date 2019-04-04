//
//  Terrain.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation

public class Terrain: Grid<TerrainChunk, TerrainTile, TerrainNode<TerrainNodeEdge<TerrainNodeEdgeLayer>>> {
    
}

extension Terrain: SceneGraphIntermediate {
    
    public typealias IntermediateType = TerrainNodeIntermediate
    
    public func load(intermediates: [IntermediateType]) {
        
        intermediates.forEach { intermediate in
        
            intermediate.children.forEach { nodeEdgeIntermediate in
                
                nodeEdgeIntermediate.children.forEach { nodeEdgeLayerIntermediate in
                    
                    if let terrainType = TerrainType(rawValue: nodeEdgeLayerIntermediate.terrainType) {
                        
                        let terrainNodeEdgeLayer = add(layer: intermediate.volume.coordinate, edge: nodeEdgeIntermediate.edge, terrainType: terrainType)
                        
                        terrainNodeEdgeLayer?.c0 = nodeEdgeLayerIntermediate.c0
                        terrainNodeEdgeLayer?.c1 = nodeEdgeLayerIntermediate.c1
                        terrainNodeEdgeLayer?.c2 = nodeEdgeLayerIntermediate.c2
                    }
                }
            }
        }
    }
}

extension Terrain {
    
    public func add(layer coordinate: Coordinate, edge: GridEdge, terrainType: TerrainType) -> TerrainNodeEdgeLayer? {
        
        let node = (find(node: coordinate) ?? add(node: coordinate))
        
        let nodeEdge = (node?.find(edge: edge) ?? node?.add(edge: edge))
        
        return nodeEdge?.add(layer: terrainType)
    }
    
    func add(node coordinate: Coordinate) -> TerrainNode<TerrainNodeEdge<TerrainNodeEdgeLayer>>? {
        
        guard let node = add(node: TerrainTile.fixedVolume(coordinate)) else { return nil }
        
        GridEdge.Edges.forEach { edge in
            
            if let neighbour = find(node: coordinate + GridEdge.extent(edge: edge)) {
                
                node.add(neighbour: neighbour, edge: edge)
            }
        }
        
        return node
    }
    
    public func find(edge coordinate: Coordinate, edge: GridEdge) -> TerrainNodeEdge<TerrainNodeEdgeLayer>? {
        
        return find(node: coordinate)?.find(edge: edge)
    }
    
    @discardableResult public func remove(layer: TerrainNodeEdgeLayer) -> Bool {
        
        guard let node = find(node: layer.coordinate) else { return false }
        
        guard let edge = node.find(edge: layer.edge) else { return false }
        
        if edge.remove(layer: layer) {
            
            if edge.totalChildren == 0 {
                
                if node.remove(edge: edge) {
                    
                    if node.totalChildren == 0 {
                        
                        return remove(node: node)
                    }
                }
            }
            
            return true
        }
        
        return false
    }
}
