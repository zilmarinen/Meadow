//
//  AreaNodeEdge.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 25/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

extension AreaNode {
    
    public struct Edge: Codable, Hashable {
        
        let edge: GridEdge
        
        let edgeType: AreaNodeEdgeType
    }
    
    public struct Edges: Codable {
        
        var north: Edge?
        var east: Edge?
        var south: Edge?
        var west: Edge?
    }
}
