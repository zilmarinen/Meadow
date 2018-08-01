//
//  GridChunkIntermediate.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 20/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public struct GridChunkIntermediate<NodeIntermediate: GridNodeIntermediate>: Decodable {
    
    let name: String?
    
    let volume: Volume
    
    let tiles: [GridTileIntermediate<NodeIntermediate>]
}
