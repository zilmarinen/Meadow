//
//  Area.swift
//  
//  Created by Zack Brown on 08/12/2020.
//

public class Area: Grid<AreaChunk, AreaTile> {
    
    public override var category: Int { SceneGraphCategory.area.rawValue }
}
