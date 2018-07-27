//
//  Scaffold.swift
//  Meadow
//
//  Created by Zack Brown on 01/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation

public class Scaffold: Grid<ScaffoldChunk, ScaffoldTile, ScaffoldNode> {
    
}

extension Scaffold {
    
    func add(node coordinate: Coordinate) -> ScaffoldNode? {
        
        return add(node: ScaffoldTile.fixedVolume(coordinate))
    }
}
