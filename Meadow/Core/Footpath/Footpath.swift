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
            
            if let footpathType = FootpathType(rawValue: intermediate.footpathType) {
            
                let node = add(node: intermediate.volume.coordinate, footpathType: footpathType)
                
                node?.slope = intermediate.slope
            }
        }
    }
}

extension Footpath {
    
    public func add(node coordinate: Coordinate, footpathType: FootpathType) -> FootpathNode? {
        
        guard let node = add(node: FootpathNode.fixedVolume(coordinate)) else { return nil }
        
        node.footpathType = footpathType
     
        return node
    }
}
