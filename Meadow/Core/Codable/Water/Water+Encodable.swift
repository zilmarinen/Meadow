//
//  Water+Encodable.swift
//  Meadow
//
//  Created by Zack Brown on 20/04/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

class WaterJSON: LayeredGridJSON<WaterChunkJSON, WaterTileJSON, WaterEdgeJSON, WaterLayerJSON> {
    
}

class WaterChunkJSON: LayeredChunkJSON<WaterTileJSON, WaterEdgeJSON, WaterLayerJSON> {
    
}

class WaterTileJSON: LayeredTileJSON<WaterEdgeJSON, WaterLayerJSON> {
    
}

class WaterEdgeJSON: EdgeJSON<WaterLayerJSON> {
    
}

class WaterLayerJSON: LayerJSON {
    
    enum CodingKeys: CodingKey {
        
        case waterType
    }
    
    let waterType: WaterType
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.waterType = try container.decode(WaterType.self, forKey: .waterType)
        
        try super.init(from: decoder)
    }
}
