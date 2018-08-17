//
//  Water.swift
//  Meadow
//
//  Created by Zack Brown on 01/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation

public class Water: Grid<WaterChunk, WaterTile, WaterNode>, GridIntermediateLoader {
    
    public typealias IntermediateType = WaterNodeIntermediate
}

extension Water {
    
    public func load(nodes: [WaterNodeIntermediate]) {
        
        nodes.forEach { intermediate in
            
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
}
