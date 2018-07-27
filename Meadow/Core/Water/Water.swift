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

extension Water {
    
    func add(node coordinate: Coordinate) -> WaterNode? {
        
        guard let node = add(node: WaterTile.fixedVolume(coordinate)) else { return nil }
        
        node.waterLevel = coordinate.y
        node.waterType = WaterType.water
        
        return node
    }
}
