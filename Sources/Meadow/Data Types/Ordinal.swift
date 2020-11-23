//
//  Ordinal.swift
//
//  Created by Zack Brown on 03/11/2020.
//

public enum Ordinal: Int, CaseIterable, Encodable {
    
    case northEast
    case northWest
    case southWest
    case southEast
}

extension Ordinal {
    
    static var corners: [Vector] = [((Cardinal.normal(cardinal: .north) + Cardinal.normal(cardinal: .east)) / 2),
                                    ((Cardinal.normal(cardinal: .north) + Cardinal.normal(cardinal: .west)) / 2),
                                    ((Cardinal.normal(cardinal: .south) + Cardinal.normal(cardinal: .west)) / 2),
                                    ((Cardinal.normal(cardinal: .south) + Cardinal.normal(cardinal: .east)) / 2)]
    
    static var Cardinals: [(Cardinal, Cardinal)] = [
    
        (.east, .north),
        (.north, .west),
        (.west, .south),
        (.south, .east)
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
