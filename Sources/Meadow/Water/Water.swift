//
//  Water.swift
//
//  Created by Zack Brown on 26/03/2021.
//

import SceneKit

public class Water: Grid<WaterChunk, WaterTile> {
    
    public override var category: Int { SceneGraphCategory.surface.rawValue }
}
