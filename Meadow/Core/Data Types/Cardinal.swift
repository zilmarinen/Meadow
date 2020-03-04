//
//  Cardinal.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Pasture

public enum Cardinal: Int, CaseIterable, Encodable {
    
    case north
    case east
    case south
    case west
}

extension Cardinal {
    
    private static var Opposites: [Cardinal] = [
    
        south,
        west,
        north,
        east
    ]
    
    private static var Ordinals: [(Ordinal, Ordinal)] = [
    
        (.northWest, .northEast),
        (.northEast, .southEast),
        (.southEast, .southWest),
        (.southWest, .northWest)
    ]
    
    private static var Normals: [Vector] = [
    
        .backward,
        .right,
        .forward,
        .left
    ]
    
    public static func opposite(cardinal: Cardinal) -> Cardinal {
        
        return Opposites[cardinal.rawValue]
    }
    
    public var opposite: Cardinal {
        
        return Cardinal.opposite(cardinal: self)
    }
    
    public static func ordinals(cardinal: Cardinal) -> (Ordinal, Ordinal) {
        
        return Ordinals[cardinal.rawValue]
    }
    
    public var ordinals: (Ordinal, Ordinal) {
        
        return Cardinal.ordinals(cardinal: self)
    }
    
    public static func normal(cardinal: Cardinal) -> Vector {
        
        return Normals[cardinal.rawValue]
    }
    
    public var normal: Vector {
        
        return Cardinal.normal(cardinal: self)
    }
}
