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

class ChunkJSON<T: TileJSON>: Decodable {
    
    let segment: Int
    let radius: Int
    let tiles: [T]
}

class TileJSON: Decodable {
    
    let identifier: Int
}

class EdgeJSON<L: LayerJSON>: Decodable {
    
    let identifier: Int
    let layers: [L]
}

class LayerJSON: Decodable {

    let identifier: Int
    let corners: LayerCorners
}
