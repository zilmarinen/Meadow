//
//  Seams.swift
//
//  Created by Zack Brown on 01/06/2021.
//

import SceneKit

public class Seams: Grid<SeamChunk, SeamTile> {
    
    public override var category: SceneGraphCategory { .seams }
    
    public var tiles: [SeamTile] { chunks.flatMap { $0.tiles } }
    
    public func find(seam identifier: String) -> SeamTile? {
        
        return tiles.first { $0.identifier == identifier }
    }
}
