//
//  Area+Encodable.swift
//  Meadow
//
//  Created by Zack Brown on 20/04/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

class AreaJSON: LayeredGridJSON<AreaChunkJSON, AreaTileJSON, AreaEdgeJSON, AreaLayerJSON> {
    
}

class AreaChunkJSON: LayeredChunkJSON<AreaTileJSON, AreaEdgeJSON, AreaLayerJSON> {
    
}

class AreaTileJSON: LayeredTileJSON<AreaEdgeJSON, AreaLayerJSON> {
    
}

class AreaEdgeJSON: EdgeJSON<AreaLayerJSON> {
    
}

class AreaLayerJSON: LayerJSON {
    
}
