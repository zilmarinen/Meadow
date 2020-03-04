//
//  Vector.swift
//  Meadow
//
//  Created by Zack Brown on 28/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Pasture

extension Vector {
    
    public init(coordinate: Coordinate) {
        
        self.init(x: Double(coordinate.x), y: World.Axis.y(y: coordinate.y), z: Double(coordinate.z))
    }
}

extension Vector {
    
    private static var Normals: [Vector] = [
    
        .backward,
        .right,
        .forward,
        .left
    ]
    
    public static func normal(cardinal: Cardinal) -> Vector {
        
        return Normals[cardinal.rawValue]
    }
}
