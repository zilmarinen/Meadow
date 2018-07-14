//
//  WaterResolver.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 14/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

/*!
 @protocol WaterResolver
 @abstract A WaterResolver is responsible for flood filling and removing neighbouring WaterNodes when TerrainNode changes are propagated.
 */
public struct WaterResolver: GridResolver {
    
    /*!
     @property water
     @abstract Water Grid type.
     */
    let water: Water
    
    /*!
     @method resolve:volume
     @astract Resolve any propagated Grid changes to the specified volume.
     @param volume The Volume that has become dirty in the associated Grid type.
     */
    public func resolve(volume: Volume) {
        
    }
}
