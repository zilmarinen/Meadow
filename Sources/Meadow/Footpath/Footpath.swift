//
//  Footpath.swift
//
//  Created by Zack Brown on 27/11/2020.
//

public class Footpath: Grid<FootpathChunk, FootpathTile> {
    
    public override var category: Int { SceneGraphCategory.footpath.rawValue }
}
