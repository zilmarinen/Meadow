//
//  Terrain+Encodable.swift
//  Meadow
//
//  Created by Zack Brown on 20/04/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

class TerrainJSON: GridJSON<TerrainChunkJSON, TerrainTileJSON<TerrainEdgeJSON>> {
    
}

class TerrainChunkJSON: ChunkJSON<TerrainTileJSON<TerrainEdgeJSON>> {
    
}

class TerrainTileJSON<E: TerrainEdgeJSON>: TileJSON {
    
    let edges: [E] = []
}

class TerrainEdgeJSON: EdgeJSON<TerrainLayerJSON> {
    
}

class TerrainLayerJSON: LayerJSON {
    
}
