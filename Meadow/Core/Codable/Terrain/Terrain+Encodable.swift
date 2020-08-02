//
//  Terrain+Encodable.swift
//  Meadow
//
//  Created by Zack Brown on 20/04/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

class TerrainJSON: LayeredGridJSON<TerrainChunkJSON, TerrainTileJSON, TerrainEdgeJSON, TerrainLayerJSON> {
    
}

class TerrainChunkJSON: LayeredChunkJSON<TerrainTileJSON, TerrainEdgeJSON, TerrainLayerJSON> {
    
}

class TerrainTileJSON: LayeredTileJSON<TerrainEdgeJSON, TerrainLayerJSON> {
    
}

class TerrainEdgeJSON: EdgeJSON<TerrainLayerJSON> {
    
}

class TerrainLayerJSON: LayerJSON {
    
    enum CodingKeys: CodingKey {
        
        case terrainType
    }
    
    let terrainType: TerrainType
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.terrainType = try container.decode(TerrainType.self, forKey: .terrainType)
        
        try super.init(from: decoder)
    }
}
