//
//  TunnelResolver.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 14/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

/*!
 @protocol TunnelResolver
 @abstract A TunnelResolver is responsible for adding and removing TunnelNodes when TerrainNode and FootpathNode changes are propagated.
 */
public struct TunnelResolver: GridResolver {
    
    /*!
     @property tunnels
     @abstract Tunnel Grid type.
     */
    let tunnels: Tunnel
    
    /*!
     @method resolve:volume
     @astract Resolve any propagated Grid changes to the specified volume.
     @param volume The Volume that has become dirty in the associated Grid type.
     */
    public func resolve(volume: Volume) {
        
    }
}
