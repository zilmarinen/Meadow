//
//  Water+Encodable.swift
//  Meadow
//
//  Created by Zack Brown on 20/04/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

class WaterJSON: GridJSON<WaterChunkJSON, WaterTileJSON<WaterEdgeJSON>> {
    
}

class WaterChunkJSON: ChunkJSON<WaterTileJSON<WaterEdgeJSON>> {
    
}

class WaterTileJSON<E: WaterEdgeJSON>: TileJSON {
    
    let edges: [E] = []
}

class WaterEdgeJSON: EdgeJSON<WaterLayerJSON> {
    
}

class WaterLayerJSON: LayerJSON {
    
}
