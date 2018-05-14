//
//  TerrainCutaway.swift
//  Meadow
//
//  Created by Zack Brown on 11/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

/*!
 @class TerrainCutaway
 @abstract TerrainCutaways define an area of space within a TerrainNode represented as a Polyhedron.
 */
public struct TerrainCutaway {
 
    /*!
     @property polyhedron
     @abstract The Polyhedron that defines the area the TerrainCutaway occupies.
     */
    let polyhedron: Polyhedron
}
