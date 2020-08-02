//
//  Footpath+Encodable.swift
//  Meadow
//
//  Created by Zack Brown on 20/04/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

class FootpathJSON: LayeredGridJSON<FootpathChunkJSON, FootpathTileJSON, FootpathEdgeJSON, FootpathLayerJSON> {
    
}

class FootpathChunkJSON: LayeredChunkJSON<FootpathTileJSON, FootpathEdgeJSON, FootpathLayerJSON> {
    
}

class FootpathTileJSON: LayeredTileJSON<FootpathEdgeJSON, FootpathLayerJSON> {

}

class FootpathEdgeJSON: EdgeJSON<FootpathLayerJSON> {
    
}

class FootpathLayerJSON: LayerJSON {
    
    enum CodingKeys: CodingKey {
        
        case footpathType
    }
    
    let footpathType: FootpathType
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.footpathType = try container.decode(FootpathType.self, forKey: .footpathType)
        
        try super.init(from: decoder)
    }
}
