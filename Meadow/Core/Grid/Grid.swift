//
//  Grid.swift
//  GDH
//
//  Created by Zack Brown on 26/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public class Grid<Chunk: GridChunk<Tile, Node>, Tile: GridTile<Node>, Node: GridNode>: SCNNode {
    
    var chunks: Set<Chunk> = []
}

extension Grid {
    
    func add(node coordinate: Coordinate) -> Node? {
        
        return nil
    }
}
