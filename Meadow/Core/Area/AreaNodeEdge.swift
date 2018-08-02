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
        
        public let externalColorPalette: ColorPalette
        public let internalColorPalette: ColorPalette
        
        public init(edge: GridEdge, edgeType: AreaNodeEdgeType, externalColorPalette: ColorPalette, internalColorPalette: ColorPalette) {
            
            self.edge = edge
            
            self.edgeType = edgeType
            
            self.externalColorPalette = externalColorPalette
            self.internalColorPalette = internalColorPalette
        }
        
        enum CodingKeys: CodingKey {
            
            case edge
            case edgeType
            case externalColorPalette
            case internalColorPalette
        }
        
        public func encode(to encoder: Encoder) throws {
            
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(self.edge, forKey: .edge)
            try container.encode(self.edgeType, forKey: .edgeType)
            try container.encode(self.externalColorPalette.name, forKey: .externalColorPalette)
            try container.encode(self.internalColorPalette.name, forKey: .internalColorPalette)
        }
    }
    
    public struct Edges: Codable {
        
        var north: Edge?
        var east: Edge?
        var south: Edge?
        var west: Edge?
    }
}
