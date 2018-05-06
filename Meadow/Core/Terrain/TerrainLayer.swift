//
//  TerrainLayer.swift
//  Meadow
//
//  Created by Zack Brown on 05/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public struct TerrainLayer {
    
    let terrainType: TerrainType
    
    var polyhedron: Polyhedron {
        
        return Polyhedron(upperPolytope: Polytope.Unit, lowerPolytope: Polytope.Unit)
    }
}

extension TerrainLayer: Hashable {
    
    public static func == (lhs: TerrainLayer, rhs: TerrainLayer) -> Bool {
        
        return lhs.terrainType == rhs.terrainType && lhs.polyhedron == rhs.polyhedron
    }
    
    public var hashValue: Int {
        
        return terrainType.hashValue
    }
}
