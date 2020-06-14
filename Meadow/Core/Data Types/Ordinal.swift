//
//  Ordinal.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Pasture

public enum Ordinal: Int, CaseIterable, Encodable {
    
    case northWest
    case northEast
    case southEast
    case southWest
}

extension Ordinal {
    
    private static var corners: [Vector] = [Vector(x: -0.5, y: 0.0, z: -0.5),
                                            Vector(x: 0.5, y: 0.0, z: -0.5),
                                            Vector(x: 0.5, y: 0.0, z: 0.5),
                                            Vector(x: -0.5, y: 0.0, z: 0.5),]
    
    public static func vector(ordinal: Ordinal) -> Vector {
        
        return corners[ordinal.rawValue]
    }
    
    var vector: Vector {
        
        return Ordinal.vector(ordinal: self)
    }
}
