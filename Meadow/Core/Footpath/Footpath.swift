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

extension Footpath {
    
    func add(node coordinate: Coordinate) -> FootpathNode? {
        
        return add(node: FootpathTile.fixedVolume(coordinate))
    }
}
