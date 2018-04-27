//
//  Grid.swift
//  GDH
//
//  Created by Zack Brown on 26/04/2018.
//  Copyright © 2018 3Squared. All rights reserved.
//

import Foundation
import SceneKit

class Grid<Chunk: GridChunk<Tile, Node>, Tile: GridTile<Node>, Node: GridNode>: SCNNode {
    
    var chunks: [Chunk] = []
}

extension Grid {
    
    func add(chunk: Chunk) {
        
        chunks.append(chunk)
    }
}
