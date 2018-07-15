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
public protocol GridResolver: class {
    
    /*!
     @property volumes
     @abstract A set of unique volumes to be resolved.
     */
    var volumes: Set<Volume> { get set }
    
    /*!
     @method enqueue:volume
     @astract Enqueue the specified volume to be resolved.
     @param volume The Volume that has become dirty in the associated Grid type.
     @discussion Only volumes with unique coordinates are stored. When a Volume is attempted to be enqueued, the Volume Coordinates x and z components are checked for equality against previously stored Volumes.
     */
    func enqueue(volume: Volume)
    
    /*!
     @method resolve
     @astract Resolve any enqueued volume changes.
     */
    func resolve()
}

extension GridResolver {
    
    /*!
     @method enqueue:volume
     @astract Enqueue the specified volume to be resolved.
     @param volume The Volume that has become dirty in the associated Grid type.
     @discussion Only volumes with unique coordinates are stored. When a Volume is attempted to be enqueued, the Volume Coordinates x and z components are checked for equality against previously stored Volumes.
     */
    public func enqueue(volume: Volume) {
        
        let existingVolume = volumes.first { $0.coordinate.adjacency(to: volume.coordinate) == .equal }
        
        if existingVolume == nil {
            
            volumes.insert(volume)
        }
    }
}
