//
//  Footpath+Encodable.swift
//  Meadow
//
//  Created by Zack Brown on 20/04/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

class FootpathJSON: GridJSON<FootpathChunkJSON, FootpathTileJSON<FootpathEdgeJSON>> {
    
}

class FootpathChunkJSON: ChunkJSON<FootpathTileJSON<FootpathEdgeJSON>> {
    
}

class FootpathTileJSON<E: FootpathEdgeJSON>: TileJSON {

    let edges: [E] = []
}

class FootpathEdgeJSON: EdgeJSON<FootpathLayerJSON> {
    
}

class FootpathLayerJSON: LayerJSON {
    
    let footpathType: FootpathType = .dirt
}
