//
//  Footpath.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation

public class Footpath: Grid<FootpathChunk, FootpathTile, FootpathNode> {
    
}

extension Footpath: SceneGraphIntermediate {
    
    public typealias IntermediateType = FootpathNodeIntermediate
    
    public func load(intermediates: [IntermediateType]) {
        
        intermediates.forEach { intermediate in
            
            if let node = add(node: intermediate.volume.coordinate) {
                
                node.footpathType = FootpathType(rawValue: intermediate.footpathType)
                node.slope = intermediate.slope
            }
        }
    }
}

extension Footpath {
    
    public func add(node coordinate: Coordinate) -> FootpathNode? {
        
        guard let node = add(node: FootpathNode.fixedVolume(coordinate)) else { return nil }
        
        node.footpathType = .asphalt
        
        GridEdge.Edges.forEach { edge in
            
            if let tile = find(tile: coordinate + GridEdge.extent(edge: edge)) {
            
                for index in 0..<tile.totalChildren {
                    
                    if let neighbour = tile.child(at: index) as? FootpathNode, (neighbour.volume.coordinate.y >= coordinate.y - 1 && neighbour.volume.coordinate.y <= coordinate.y + 1) {
                        
                        node.add(neighbour: neighbour, edge: edge)
                    }
                }
            }
        }
     
        return node
    }
}
