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
public struct FoliageResolver: GridResolver {
    
    /*!
     @property foliage
     @abstract Foliage Grid type.
     */
    let foliage: Foliage
    
    /*!
     @method resolve:volume
     @astract Resolve any propagated Grid changes to the specified volume.
     @param volume The Volume that has become dirty in the associated Grid type.
     */
    public func resolve(volume: Volume) {
        
    }
}
