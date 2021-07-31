//
//  Cardinal.swift
//
//  Created by Zack Brown on 03/11/2020.
//

import Euclid

public enum Cardinal: Int, CaseIterable, Codable, Identifiable {
    
    case north
    case east
    case south
    case west
    
    public var description: String {
            
        switch self {
            
        case .north: return "North"
        case .east: return "East"
        case .south: return "South"
        case .west: return "West"
        }
    }
    
    public var id: String { description }
}

extension Cardinal {
    
    static var Coordinates: [Coordinate] = [
    
        .forward,
        .right,
        -.forward,
        -.right
    ]
    
    static var Cardinals: [(Cardinal, Cardinal)] = [
    
        (.west, .east),
        (.north, .south),
        (.east, .west),
        (.south, .north)
    ]
    
    static var Opposites: [Cardinal] = [
    
        south,
        west,
        north,
        east
    ]
    
    static var Ordinals: [(Ordinal, Ordinal)] = [
    
        (.northWest, .northEast),
        (.northEast, .southEast),
        (.southEast, .southWest),
        (.southWest, .northWest)
    ]
    
    static var Normals: [Vector] = [
        
        .forward,
        .right,
        -.forward,
        -.right
    ]
    
    static func cardinals(cardinal: Cardinal) -> (Cardinal, Cardinal) {
        
        return Cardinals[cardinal.rawValue]
    }
    
    public var cardinals: (Cardinal, Cardinal) {
        
        return Cardinal.cardinals(cardinal: self)
    }
    
    static func opposite(cardinal: Cardinal) -> Cardinal {
        
        return Opposites[cardinal.rawValue]
    }
    
    public var opposite: Cardinal {
        
        return Cardinal.opposite(cardinal: self)
    }
    
    static func ordinals(cardinal: Cardinal) -> (Ordinal, Ordinal) {
        
        return Ordinals[cardinal.rawValue]
    }
    
    public var ordinals: (Ordinal, Ordinal) {
        
        return Cardinal.ordinals(cardinal: self)
    }
    
    static func normal(cardinal: Cardinal) -> Vector {
        
        return Normals[cardinal.rawValue]
    }
    
    public var normal: Vector {
        
        return Cardinal.normal(cardinal: self)
    }
    
    static func coordinate(cardinal: Cardinal) -> Coordinate {
        
        return Coordinates[cardinal.rawValue]
    }
    
    public var coordinate: Coordinate {
        
        return Cardinal.coordinate(cardinal: self)
    }
    
    func rotate(rotation: Cardinal) -> Cardinal {
        
        return Cardinal(rawValue: (rawValue + rotation.rawValue) % 4)!
    }
}
