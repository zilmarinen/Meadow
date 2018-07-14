//
//  ScaffoldResolver.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 14/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

/*!
 @protocol ScaffoldResolver
 @abstract A ScaffoldResolver is responsible for adding and removing ScaffoldNodes when TerrainNode and FootpathNode changes are propagated.
 */
public struct ScaffoldResolver: GridResolver {
    
    /*!
     @property scaffolds
     @abstract Scaffold Grid type.
     */
    let scaffolds: Scaffold
    
    /*!
     @method resolve:volume
     @astract Resolve any propagated Grid changes to the specified volume.
     @param volume The Volume that has become dirty in the associated Grid type.
     */
    public func resolve(volume: Volume) {
        
    }
}
