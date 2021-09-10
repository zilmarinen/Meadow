//
//  Cardinal.swift
//
//  Created by Zack Brown on 03/11/2020.
//

import Euclid

public struct Cardinal: OptionSet, CaseIterable, Codable, Hashable, Identifiable {
    
    public static let north = Cardinal(rawValue: 1 << 0)
    public static let east = Cardinal(rawValue: 1 << 1)
    public static let south = Cardinal(rawValue: 1 << 2)
    public static let west = Cardinal(rawValue: 1 << 3)
    
    public static var allCases: [Cardinal] = [.north,
                                             .east,
                                             .south,
                                             .west]
    
    public let rawValue: Int
    
    public init(rawValue: Int) {
        
        self.rawValue = rawValue
    }
    
    public var id: String { description }
    
    public var description: String {
        
        switch self {
            
        case .north: return "North"
        case .east: return "East"
        case .south: return "South"
        default: return "West"
        }
    }
    
    public var edge: Int {
        
        switch self {
            
        case .east,
             [.east, .south],
             [.east, .south, .west]: return 1
            
        case [.south],
             [.south, .west],
             [.south, .west, .north]: return 2
            
        case .west,
             [.west, .north],
             [.west, .north, .east]: return 3
            
        default: return 0
        }
    }
    
    public var count: Int {
        
        switch self {
        
        case .north,
             .east,
             .south,
             .west: return 1
            
        case [.north, .east],
             [.east, .south],
             [.south, .west],
             [.west, .north]: return 2
            
        case [.north, .east, .south, .west]: return 4
            
        default: return 3
        }
    }
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
    
    static func cardinals(cardinal: Cardinal) -> (Cardinal, Cardinal) { Cardinals[cardinal.edge] }
    
    public var cardinals: (Cardinal, Cardinal) { Cardinal.cardinals(cardinal: self) }
    
    static func opposite(cardinal: Cardinal) -> Cardinal { Opposites[cardinal.edge] }
    
    public var opposite: Cardinal { Cardinal.opposite(cardinal: self) }
    
    static func ordinals(cardinal: Cardinal) -> (Ordinal, Ordinal) { Ordinals[cardinal.edge] }
    
    public var ordinals: (Ordinal, Ordinal) { Cardinal.ordinals(cardinal: self) }
    
    static func normal(cardinal: Cardinal) -> Vector { Normals[cardinal.edge] }
    
    public var normal: Vector { Cardinal.normal(cardinal: self) }
    
    static func coordinate(cardinal: Cardinal) -> Coordinate { Coordinates[cardinal.edge] }
    
    public var coordinate: Coordinate { Cardinal.coordinate(cardinal: self) }
}
