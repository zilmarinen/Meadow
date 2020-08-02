//
//  Grid+Encodable.swift
//  Meadow
//
//  Created by Zack Brown on 20/04/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

class GridJSON<C: ChunkJSON<T>, T: TileJSON>: Decodable {

    let chunks: [C]
}

class LayeredGridJSON<C: LayeredChunkJSON<T, E, L>, T: LayeredTileJSON<E, L>, E: EdgeJSON<L>, L: LayerJSON>: Decodable {
    
    let chunks: [C]
}

class ChunkJSON<T: TileJSON>: Decodable {
    
    let segment: Int
    let radius: Int
    let tiles: [T]
}

class LayeredChunkJSON<T: LayeredTileJSON<E, L>, E: EdgeJSON<L>, L: LayerJSON>: Decodable {
    
    let segment: Int
    let radius: Int
    let tiles: [T]
}

class TileJSON: Decodable {
    
    let identifier: Int
}

class LayeredTileJSON<E: EdgeJSON<L>, L: LayerJSON>: Decodable {
 
    let identifier: Int
    let edges: [E]
}

class EdgeJSON<L: LayerJSON>: Decodable {
    
    let identifier: Int
    let layers: [L]
}

class LayerJSON: Decodable {
    
    private enum CodingKeys: CodingKey {
        
        case identifier
        case corners
    }

    let identifier: Int
    let corners: LayerCorners
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.identifier = try container.decode(Int.self, forKey: .identifier)
        self.corners = try container.decode(LayerCorners.self, forKey: .corners)
    }
}
