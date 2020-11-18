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
    
    static var Cardinals: [(Cardinal, Cardinal)] = [
    
        (.west, .north),
        (.north, .east),
        (.east, .south),
        (.south, .west)
    ]
    
    static func vector(ordinal: Ordinal) -> Vector {
        
        return corners[ordinal.rawValue]
    }
    
    var vector: Vector {
        
        return Ordinal.vector(ordinal: self)
    }
    
    static func cardinals(ordinal: Ordinal) -> (Cardinal, Cardinal) {
        
        return Cardinals[ordinal.rawValue]
    }
    
    var cardinals: (Cardinal, Cardinal) {
        
        return Ordinal.cardinals(ordinal: self)
    }
}
