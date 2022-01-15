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
    
    public var id: String {
    
        switch self {
            
        case .north: return "North"
        case .east: return "East"
        case .south: return "South"
        default: return "West"
        }
    }
    
    public var direction: Vector {
        
        switch self {
            
        case .east: return Vector(x: 1, y: 0, z: 0)
        case .south: return Vector(x: 0, y: 0, z: 1)
        case .west: return Vector(x: -1, y: 0, z: 0)
        default: return Vector(x: 0, y: 0, z: -1)
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
    
    public var cardinals: (Cardinal, Cardinal) { Self.Cardinals[self.edge] }
    
    public var opposite: Cardinal { Self.Opposites[self.edge] }
    
    public var ordinals: (Ordinal, Ordinal) { Self.Ordinals[self.edge] }
    
    public var coordinate: Coordinate { Self.Coordinates[self.edge] }
}
