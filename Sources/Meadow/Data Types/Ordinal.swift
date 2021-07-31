//
//  Ordinal.swift
//
//  Created by Zack Brown on 03/11/2020.
//

import Foundation

public enum Ordinal: Int, CaseIterable, Codable {
    
    case northWest
    case northEast
    case southEast
    case southWest
    
    public var description: String {
            
        switch self {
            
        case .northWest: return "\(Cardinal.north.description) \(Cardinal.west.description)"
        case .northEast: return "\(Cardinal.north.description) \(Cardinal.east.description)"
        case .southEast: return "\(Cardinal.south.description) \(Cardinal.east.description)"
        case .southWest: return "\(Cardinal.south.description) \(Cardinal.west.description)"
        }
    }
}

extension Ordinal {
    
    public static var uvs: [CGPoint] = [CGPoint(x: 0.0, y: 0.0),
                                 CGPoint(x: 1.0, y: 0.0),
                                 CGPoint(x: 1.0, y: 1.0),
                                 CGPoint(x: 0.0, y: 1.0)]
    
    public static var Coordinates: [Coordinate] = [
    
        .forward + -.right,
        .forward + .right,
        -.forward + .right,
        -.forward + -.right
    ]
    
    static var Cardinals: [(Cardinal, Cardinal)] = [
    
        (.west, .north),
        (.north, .east),
        (.east, .south),
        (.south, .west)
    ]
    
    static var Opposites: [Ordinal] = [
    
        southEast,
        southWest,
        northWest,
        northEast
    ]
    
    static var Ordinals: [(Ordinal, Ordinal)] = [
    
        (.southWest, .northEast),
        (.northWest, .southEast),
        (.northEast, .southWest),
        (.southEast, .northWest)
    ]
    
    static func cardinals(ordinal: Ordinal) -> (Cardinal, Cardinal) {
        
        return Cardinals[ordinal.rawValue]
    }
    
    public var cardinals: (Cardinal, Cardinal) {
        
        return Ordinal.cardinals(ordinal: self)
    }
    
    static func opposite(ordinal: Ordinal) -> Ordinal {
        
        return Opposites[ordinal.rawValue]
    }
    
    public var opposite: Ordinal {
        
        return Ordinal.opposite(ordinal: self)
    }
    
    static func ordinals(ordinal: Ordinal) -> (Ordinal, Ordinal) {
        
        return Ordinals[ordinal.rawValue]
    }
    
    public var ordinals: (Ordinal, Ordinal) {
        
        return Ordinal.ordinals(ordinal: self)
    }
    
    static func coordinate(ordinal: Ordinal) -> Coordinate {
        
        return Coordinates[ordinal.rawValue]
    }
    
    public var coordinate: Coordinate {
        
        return Ordinal.coordinate(ordinal: self)
    }
    
    public var next: Ordinal {
        
        return Ordinal(rawValue: (rawValue + 1) % 4)!
    }
    
    public var previous: Ordinal {
        
        return Ordinal(rawValue: (rawValue - 1 + 4) % 4)!
    }
}
