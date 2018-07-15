//
//  ScaffoldResolver.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 14/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

/*!
 @protocol ScaffoldResolver
 @abstract A ScaffoldResolver is responsible for adding and removing ScaffoldNodes when TerrainNode, AreaNode and FootpathNode changes are propagated.
 */
public class ScaffoldResolver: GridResolver {
    
    /*!
     @property scaffolds
     @abstract Scaffold Grid type.
     */
    let scaffolds: Scaffold
    
    /*!
     @property areas
     @abstract Area Grid type.
     */
    let areas: Area
    
    /*!
     @property footpaths
     @abstract Footpath Grid type.
     */
    let footpaths: Footpath
    
    /*!
     @property terrain
     @abstract Terrain Grid type.
     */
    let terrain: Terrain
    
    /*!
     @property volumes
     @abstract A set of unique volumes to be resolved.
     */
    public var volumes: Set<Volume>
    
    /*!
     @method init:scaffolds:areas:footpaths:terrain
     @abstract Creates and initialises a resolver with the specified grid.
     @param scaffolds The Scaffold Grid to resolve.
     @param areas The Area Grid data source.
     @param footpaths The Footpath Grid data source.
     @param terrain The Terrain Grid data source.
     */
    init(scaffolds: Scaffold, areas: Area, footpaths: Footpath, terrain: Terrain) {
        
        self.scaffolds = scaffolds
        
        self.areas = areas
        self.footpaths = footpaths
        self.terrain = terrain
        
        self.volumes = Set<Volume>()
    }
    
    /*!
     @method resolve
     @astract Resolve any enqueued volume changes.
     */
    public func resolve() {
        
    }
}
