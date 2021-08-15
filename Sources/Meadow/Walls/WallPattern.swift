//
//  WallPattern.swift
//
//  Created by Zack Brown on 11/08/2021.
//

import Foundation

public struct WallPattern: OptionSet, Codable {
    
    public let rawValue: Int
    
    public init(rawValue: Int) {
        
        self.rawValue = rawValue
    }
    
    public init(cardinal: Cardinal) {
        
        switch cardinal {
        
        case .north: self = .north
        case .east: self = .east
        case .south: self = .south
        case .west: self = .west
        }
    }
    
    public static let north = WallPattern(rawValue: 1 << 0)
    public static let east = WallPattern(rawValue: 1 << 1)
    public static let south = WallPattern(rawValue: 1 << 2)
    public static let west = WallPattern(rawValue: 1 << 3)
    
    var edges: Int {
        
        switch self {
        
        case .north,
             .east,
             .south,
             .west:
            
            return 1
            
        case [.north, .east],
             [.east, .south],
             [.south, .west],
             [.west, .north]:
            
            return 2
            
        case [.north, .east, .south, .west]:
            
            return 4
            
        default:
            
            return 3
        }
    }
    
    var rotation: Cardinal {
        
        switch self {
        
        case .east,
             [.east, .south],
             [.east, .south, .west]:
            
            return .east
            
        case [.south],
             [.south, .west],
             [.south, .west, .north]:
            
            return .south
            
        case .west,
             [.west, .north],
             [.west, .north, .east]:
            
            return .west
            
        default:
            
            return .north
        }
    }
}
