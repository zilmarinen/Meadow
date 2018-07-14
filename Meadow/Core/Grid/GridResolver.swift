//
//  GridResolver.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 14/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

/*!
 @protocol GridResolver
 @abstract Objects implementing the GridResolver protocol are responsible for resolving any changes between associated Grid types.
 */
public protocol GridResolver {
    
    /*!
     @method resolve:volume
     @astract Resolve any propagated Grid changes to the specified volume.
     @param volume The Volume that has become dirty in the associated Grid type.
     */
    func resolve(volume: Volume)
}
