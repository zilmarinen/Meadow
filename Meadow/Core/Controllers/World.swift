//
//  World.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import CoreGraphics

/*!
 @enum World
 @abstract Defines various constant values for constraining world grid coordinates.
 */
public enum World {
    
    /*!
     @property Ceiling
     @abstract The highest y axis value allowed.
     */
    public static var Ceiling: Int = 10
    
    /*!
     @property Floor
     @abstract The lowest y axis value allowed.
     */
    public static var Floor: Int = -10
    
    /*!
     @property UnitXZ
     @abstract The unit length for both x and z axis along which a GridTile vertices extend.
     */
    static var UnitXZ: MDWFloat = 0.5
    
    /*!
     @property UnitY
     @abstract The unit length for a single y axis value increment.
     */
    static var UnitY: MDWFloat = 0.25
    
    /*!
     @property ChunkSize
     @abstract The square root of the number of GridTiles contained in a GridChunk.
     */
    static var ChunkSize: Int = 5
    
    /*!
     @property TileSize
     @abstract The maximum size for a GridTile.
     */
    static var TileSize: Int = 1
}

extension World {
    
    /*!
     @method Y:y
     @abstract Convert from integer value grid coordinates to floating point world coordinates.
     */
    public static func Y(y: Int) -> MDWFloat {
        
        return MDWFloat(y) * UnitY
    }
    
    /*!
     @method Y:y
     @abstract Convert from floating point world coordinates to integer value grid coordinates.
     */
    public static func Y(y: MDWFloat) -> Int {
        
        return Int(y / UnitY)
    }
}
