//
//  Area.swift
//  Meadow
//
//  Created by Zack Brown on 01/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation

public class Area: Grid<AreaChunk, AreaTile, AreaNode> {
    
}

extension Area {
    
    public func add(node coordinate: Coordinate) -> AreaNode? {
        
        return add(node: AreaNode.fixedVolume(coordinate))
    }
}
