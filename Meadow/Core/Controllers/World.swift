//
//  World.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public enum World {
    
    static var Ceiling: Int = 10
    static var Floor: Int = -10
    
    static var UnitXZ: CGFloat = 0.5
    static var UnitY: CGFloat = 0.25
    
    static var ChunkSize: Int = 5
    static var TileSize: Int = 1
}

extension World {
    
    static func Y(y: Int) -> CGFloat {
        
        return CGFloat(y) * UnitY
    }
}
