//
//  Terrain.swift
//
//  Created by Zack Brown on 02/11/2020.
//

public class Terrain: Grid<TerrainChunk, TerrainTile> {
    
    public override var category: Int { SceneGraphCategory.terrain.rawValue }
}
