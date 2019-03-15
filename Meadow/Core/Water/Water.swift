//
//  Water.swift
//  Meadow
//
//  Created by Zack Brown on 01/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation

public class Water: Grid<WaterChunk, WaterTile, WaterNode<WaterNodeEdge>> {
    
}

extension Water: SceneGraphIntermediate {
    
    public typealias IntermediateType = WaterNodeIntermediate
    
    public func load(intermediates: [IntermediateType]) {
        
        intermediates.forEach { intermediate in
            
            if let node = add(node: intermediate.volume.coordinate) {
                
                intermediate.children.forEach { nodeEdgeIntermediate in
                    
                    if let waterType = WaterType(rawValue: nodeEdgeIntermediate.waterType) {
                        
                        let nodeEdge = node.add(edge: nodeEdgeIntermediate.edge, waterType: waterType)
                        
                        nodeEdge?.waterLevel = nodeEdgeIntermediate.waterLevel
                    }
                }
            }
        }
    }
}

extension Water {
    
    public func add(edge coordinate: Coordinate, edge: GridEdge, waterType: WaterType) -> WaterNodeEdge? {
        
        let node = (find(node: coordinate) ?? add(node: coordinate))
        
        return (node?.find(edge: edge) ?? node?.add(edge: edge, waterType: waterType))
    }
    
    func add(node coordinate: Coordinate) -> WaterNode<WaterNodeEdge>? {
        
        guard let node = add(node: WaterTile.fixedVolume(coordinate)) else { return nil }
        
        GridEdge.Edges.forEach { edge in
            
            if let neighbour = find(node: coordinate + GridEdge.extent(edge: edge)) {
                
                node.add(neighbour: neighbour, edge: edge)
            }
        }
        
        return node
    }
    
    public func find(edge coordinate: Coordinate, edge: GridEdge) -> WaterNodeEdge? {
        
        return find(node: coordinate)?.find(edge: edge)
    }
    
    @discardableResult public func remove(edge: WaterNodeEdge) -> Bool {
        
        guard let node = find(node: edge.volume.coordinate) else { return false }
        
        if node.remove(edge: edge) {
            
            if node.totalChildren == 0 {
                
                return remove(node: node)
            }
            
            return true
        }
        
        return false
    }
}
