//
//  GridNodeNeighbour.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 20/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

extension GridNode {
    
    public struct Neighbour: Hashable {
        
        let edge: GridEdge
        
        let node: GridNode
    }
    
    public struct Neighbours {
        
        var north: Neighbour?
        var east: Neighbour?
        var south: Neighbour?
        var west: Neighbour?
    }
}
