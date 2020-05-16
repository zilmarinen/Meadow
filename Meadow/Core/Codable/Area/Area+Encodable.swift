//
//  Area+Encodable.swift
//  Meadow
//
//  Created by Zack Brown on 20/04/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

class AreaJSON: GridJSON<AreaChunkJSON, AreaTileJSON<AreaEdgeJSON>> {
    
}

class AreaChunkJSON: ChunkJSON<AreaTileJSON<AreaEdgeJSON>> {
    
}

class AreaTileJSON<E: AreaEdgeJSON>: TileJSON {
    
    let edges: [E] = []
}

class AreaEdgeJSON: EdgeJSON<AreaLayerJSON> {
    
}

class AreaLayerJSON: LayerJSON {
    
}
