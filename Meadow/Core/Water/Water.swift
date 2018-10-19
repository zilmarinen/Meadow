//
//  Water.swift
//  Meadow
//
//  Created by Zack Brown on 01/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation

public class Water: Grid<WaterChunk, WaterTile, WaterNode> {
    
}

extension Water: SceneGraphIntermediate {
    
    public typealias IntermediateType = WaterNodeIntermediate
    
    public func load(intermediates: [IntermediateType]) {
        
        intermediates.forEach { intermediate in
            
            if let node = add(node: intermediate.volume.coordinate) {
                
                node.waterLevel = intermediate.waterLevel
                node.waterType = WaterType(rawValue: intermediate.waterType)
            }
        }
    }
}

extension Water {
    
    public func add(node coordinate: Coordinate) -> WaterNode? {
        
        guard let node = add(node: WaterTile.fixedVolume(coordinate)) else { return nil }
        
        node.waterLevel = coordinate.y
        node.waterType = WaterType.water
        
        GridEdge.Edges.forEach { edge in
            
            if let neighbour = find(node: coordinate + GridEdge.extent(edge: edge)) {
                
                node.add(neighbour: neighbour, edge: edge)
            }
        }
        
        return node
    }
    
    public func drain(node: WaterNode) -> Bool {
        
        GridEdge.Edges.forEach { edge in
            
            if let neighbour = node.find(neighbour: edge)?.node as? WaterNode {
                
                let _ = node.remove(neighbour: edge)
                
                let _ = drain(node: neighbour)
            }
        }
        
        return super.remove(node: node)
    }
}
