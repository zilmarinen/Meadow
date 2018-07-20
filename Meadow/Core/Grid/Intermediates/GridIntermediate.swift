//
//  GridIntermediate.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 20/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public struct GridIntermediate<NodeIntermediate: GridNodeIntermediate> {
    
    let name: String?
    
    let chunks: [GridChunkIntermediate<NodeIntermediate>]
}
