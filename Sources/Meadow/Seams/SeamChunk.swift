//
//  SeamChunk.swift
//
//  Created by Zack Brown on 01/06/2021.
//

import SceneKit

public class SeamChunk: Chunk<SeamTile> {
    
    public override var category: Int { SceneGraphCategory.seamChunk.rawValue }
}
