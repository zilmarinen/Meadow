//
//  Buildings.swift
//
//  Created by Zack Brown on 26/01/2021.
//

public class Buildings: LayeredGrid<BuildingChunk, BuildingTile, BuildingLayer> {
    
    public override var category: Int { SceneGraphCategory.buildings.rawValue }
}
