//
//  Footpath.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation

public class Footpath: Grid<FootpathChunk, FootpathTile, FootpathNode>, GridIntermediateLoader {
    
    public typealias IntermediateType = FootpathNodeIntermediate
}

extension Footpath {
    
    public func load(nodes: [FootpathNodeIntermediate]) {
        
        nodes.forEach { intermediate in
            
            if let node = add(node: intermediate.volume.coordinate) {
                
                //
            }
        }
    }
}

extension Footpath {
    
    public func add(node coordinate: Coordinate) -> FootpathNode? {
        
        guard let node = add(node: FootpathTile.fixedVolume(coordinate)) else { return nil }
        
        node.footpathType = .asphalt
     
        return node
    }
}
