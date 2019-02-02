//
//  AreaNodeEdgeIntermediate.swift
//  Meadow
//
//  Created by Zack Brown on 25/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public struct AreaNodeEdgeIntermediate: Codable {
    
    let edge: GridEdge
    
    let edgeType: AreaNodeEdgeType
    
    let architectureType: AreaArchitectureType
    
    let externalColorPalette: String
    let internalColorPalette: String
}

public struct AreaNodeEdgesIntermediate: Codable {
    
    let north: AreaNodeEdgeIntermediate?
    let east: AreaNodeEdgeIntermediate?
    let south: AreaNodeEdgeIntermediate?
    let west: AreaNodeEdgeIntermediate?
    
    func find(edge: GridEdge) -> AreaNodeEdgeIntermediate? {
        
        switch edge {
            
        case .north: return north
        case .east: return east
        case .south: return south
        case .west: return west
        }
    }
}
