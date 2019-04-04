//
//  TerrainNodeEdgeLayerCorner.swift
//  Meadow
//
//  Created by Zack Brown on 17/03/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

struct TerrainNodeEdgeLayerCorner: Equatable, Codable {
    
    enum Corner: Int, Codable {
        
        case c0
        case c1
        case c2
    }
    
    let corner: Corner
    let height: Int
}
