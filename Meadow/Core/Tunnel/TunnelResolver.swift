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
public class TunnelResolver: GridResolver {
    
    /*!
     @property tunnels
     @abstract Tunnel Grid type.
     */
    let tunnels: Tunnel
    
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
     @property water
     @abstract Water Grid type.
     */
    let water: Water
    
    /*!
     @property volumes
     @abstract A set of unique volumes to be resolved.
     */
    public var volumes: Set<Volume>
    
    /*!
     @method init:tunnels:footpaths:terrain:water
     @abstract Creates and initialises a resolver with the specified grid.
     @param tunnels The Tunnel Grid to resolve.
     @param footpaths The Footpath Grid data source.
     @param terrain The Terrain Grid data source.
     @param water The Water Grid data source.
     */
    init(tunnels: Tunnel, footpaths: Footpath, terrain: Terrain, water: Water) {
        
        self.tunnels = tunnels
        
        self.footpaths = footpaths
        self.terrain = terrain
        self.water = water
        
        self.volumes = Set<Volume>()
    }
    
    /*!
     @method resolve
     @astract Resolve any enqueued volume changes.
     */
    public func resolve() {
        
        while volumes.count > 0 {
            
            let volume = volumes.removeFirst()
            
            print("volume: \(volume)")
        }
    }
}
