//
//  Foliage.swift
//
//  Created by Zack Brown on 07/12/2020.
//

public class Foliage: Grid<FoliageChunk, FoliageTile> {
    
    public override var category: Int { SceneGraphCategory.foliage.rawValue }
}
