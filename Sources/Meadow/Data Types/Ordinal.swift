//
//  Ordinal.swift
//
//  Created by Zack Brown on 03/11/2020.
//

public enum Ordinal: Int, CaseIterable, Encodable {
    
    case northWest
    case northEast
    case southEast
    case southWest
}

extension Ordinal {
    
    static var corners: [Vector] = [((Vector.forward + Vector.left) / 2),
                                    ((Vector.forward + Vector.right) / 2),
                                    ((Vector.backward + Vector.right) / 2),
                                    ((Vector.backward + Vector.left) / 2)]
    
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
