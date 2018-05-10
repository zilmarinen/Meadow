//
//  Volume.swift
//  Meadow
//
//  Created by Zack Brown on 30/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

/*!
 @struct Volume
 @abstract Defines a Volume with a Coordinate and a Size.
 */
public struct Volume {
    
    /*!
     @property coordinate
     @abstract The coordinate of the Volume.
     */
    let coordinate: Coordinate
    
    /*!
     @property size
     @abstract The size of the Volume.
     */
    let size: Size
    
    /*!
     @method init:coordinate:size
     @abstract Creates and initialises a Volume with the specified coordinate and size components.
     @param coordinate The coordinate of the Volume.
     @param size The size of the Volume.
     */
    public init(coordinate: Coordinate, size: Size) {
        
        self.coordinate = coordinate
        self.size = size
    }
}

extension Volume: Hashable {
    
    public static func == (lhs: Volume, rhs: Volume) -> Bool {
        
        return lhs.coordinate == rhs.coordinate && lhs.size == rhs.size
    }
    
    public var hashValue: Int {
        
        return coordinate.x ^ coordinate.y ^ coordinate.z ^ size.width ^ size.height ^ size.depth
    }
}

extension Volume {
    
    /*!
     @method Contains:coordinate
     @abstract Determines if a given coordinate is within the bounds of the Volume.
     @discussion A coordinate is determined to be within the bounds of a volume when all x, y and x components of the coordinate are either greater than, or equal to, and also less than the x, y and z components of the volume inclusive of its width, height and depth.
     */
    func contains(coordinate other: Coordinate) -> Bool {
        
        if other.x >= coordinate.x && other.x < (coordinate.x + size.width) &&
            other.y >= coordinate.y && other.y < (coordinate.y + size.height) &&
            other.z >= coordinate.z && other.z < (coordinate.z + size.depth) {
            
            return true
        }
        
        return false
    }
}
