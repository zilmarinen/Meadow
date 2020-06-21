//
//  Ordinal.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Pasture
import SceneKit

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
    
    static func closest(vector: Vector) -> Ordinal {
        
        var match = Ordinal.northWest
        
        var smallestDistance = Double.infinity
        
        let x = Double(World.Axis.xz(value: vector.x))
        let z = Double(World.Axis.xz(value: vector.z))
        
        let centre = Vector(x: x, y: vector.y, z: z)
        
        Ordinal.allCases.forEach { ordinal in
            
            let corner = centre + ordinal.vector
            
            let distance = (corner - vector).magnitude
            
            if distance < smallestDistance {
                
                match = ordinal
                
                smallestDistance = distance
            }
        }
        
        return match
    }
}
