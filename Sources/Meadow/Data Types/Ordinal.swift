//
//  Ordinal.swift
//
//  Created by Zack Brown on 03/11/2020.
//

enum Ordinal: Int, CaseIterable, Encodable {
    
    case northWest
    case northEast
    case southEast
    case southWest
}

extension Ordinal {
    
    static var corners: [Vector] = [Vector(x: -0.5, y: 0.0, z: -0.5),
                                            Vector(x: 0.5, y: 0.0, z: -0.5),
                                            Vector(x: 0.5, y: 0.0, z: 0.5),
                                            Vector(x: -0.5, y: 0.0, z: 0.5),]
    
    static func vector(ordinal: Ordinal) -> Vector {
        
        return corners[ordinal.rawValue]
    }
    
    var vector: Vector {
        
        return Ordinal.vector(ordinal: self)
    }
}
