//
//  FoliageResolver.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 14/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

/*!
 @protocol FoliageResolver
 @abstract A FoliageResolver is responsible for updating FoliageNodes when TerrainNode changes are propagated.
 */
public class FoliageResolver: GridResolver {
    
    /*!
     @property foliage
     @abstract Foliage Grid type.
     */
    let foliage: Foliage
    
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
     @method init:foliage:terrain
     @abstract Creates and initialises a resolver with the specified grid.
     @param foliage The Foliage Grid to resolve.
     @param terrain The Terrain Grid data source.
     */
    init(foliage: Foliage, terrain: Terrain) {
        
        self.foliage = foliage
        
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
