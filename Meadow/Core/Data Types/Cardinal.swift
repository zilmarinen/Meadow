//
//  Cardinal.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

enum Cardinal: Int, CaseIterable, Encodable {
    
    case north
    case east
    case south
    case west
}

extension Cardinal {
    
    private static var Opposites: [Cardinal] { return [
    
        south,
        west,
        north,
        east
    ]}
    
    private static var Ordinals: [(Ordinal, Ordinal)] { return [
    
        (.northEast, .northWest),
        (.northEast, .southEast),
        (.southEast, .southWest),
        (.southWest, .northWest)
    ]}
    
    public static func opposite(_ cardinal: Cardinal) -> Cardinal {
        
        return Opposites[cardinal.rawValue]
    }
    
    var opposite: Cardinal {
        
        return Cardinal.opposite(self)
    }
    
    public static func ordinals(_ cardinal: Cardinal) -> (Ordinal, Ordinal) {
        
        return Ordinals[cardinal.rawValue]
    }
}
