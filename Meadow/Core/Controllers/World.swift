//
//  World.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

/*!
 @enum World
 @abstract Defines various constant values for constraining world grid coordinates.
 */
public enum World {
    
    static var Ceiling: Int = 10
    static var Floor: Int = -10
    
    static var UnitXZ: CGFloat = 0.5
    static var UnitY: CGFloat = 0.25
    
    static var ChunkSize: Int = 5
    static var TileSize: Int = 1
}

extension World {
    
    /*!
     @method Y:y
     @abstract Convert from integer value grid coordinates to floating point world coordinates.
     */
    static func Y(y: Int) -> CGFloat {
        
        return CGFloat(y) * UnitY
    }
    
    /*!
     @method Y:y
     @abstract Convert from floating point world coordinates to integer value grid coordinates.
     */
    static func Y(y: CGFloat) -> Int {
        
        return Int(y / UnitY)
    }
}
