//
//  TerrainChunk.swift
//
//  Created by Zack Brown on 02/11/2020.
//

import SceneKit

public class TerrainChunk: Chunk<TerrainTile> {
    
    public override var category: Int { SceneGraphCategory.terrainChunk.rawValue }
    
    override var program: SCNProgram? {
        
        guard let library = library else { return nil }
        
        return SCNProgram(name: "terrain", library: library)
    }
    
    override var uniforms: [Uniform]? { nil }
    
    override var textures: [Texture]? {
        
        guard let tilemap = scene?.world.tilemaps.terrain else { return [] }
        
        return [Texture(key: "edgeset", image: tilemap.edgeset.image),
                Texture(key: "tileset", image: tilemap.tileset.image)]
    }
}
