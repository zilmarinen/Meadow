//
//  AreaNodeEdge.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 25/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

extension AreaNode {
    
    public struct Edge: Codable {
        
        public let edge: GridEdge
        
        public let edgeType: AreaNodeEdgeType
        
        public let colorPalette: ColorPalette
        
        public init(edge: GridEdge, edgeType: AreaNodeEdgeType, colorPalette: ColorPalette) {
            
            self.edge = edge
            
            self.edgeType = edgeType
            
            self.colorPalette = colorPalette
        }
    }
    
    public struct Edges: Codable {
        
        var north: Edge?
        var east: Edge?
        var south: Edge?
        var west: Edge?
    }
}
