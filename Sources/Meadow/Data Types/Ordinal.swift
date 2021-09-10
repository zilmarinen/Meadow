//
//  Ordinal.swift
//
//  Created by Zack Brown on 03/11/2020.
//

import Euclid
import Foundation

public struct Ordinal: OptionSet, CaseIterable, Codable, Hashable, Identifiable {
    
    public static let northWest = Ordinal(rawValue: 1 << 0)
    public static let northEast = Ordinal(rawValue: 1 << 1)
    public static let southEast = Ordinal(rawValue: 1 << 2)
    public static let southWest = Ordinal(rawValue: 1 << 3)
    
    public static var allCases: [Ordinal] = [.northWest,
                                             .northEast,
                                             .southEast,
                                             .southWest]
    
    public let rawValue: Int
    
    public init(rawValue: Int) {
        
        self.rawValue = rawValue
    }
    
    public var id: String { description }
    
    public var description: String {
        
        switch self {
            
        case .northWest: return "North West"
        case .northEast: return "North East"
        case .southEast: return "South East"
        default: return "South West"
        }
    }
    
    public var corner: Int {
        
        switch self {
            
        case .northWest: return 0
        case .northEast: return 1
        case .southEast: return 2
        default: return 3
        }
    }
}

extension Ordinal {
    
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
    
    static func cardinals(ordinal: Ordinal) -> (Cardinal, Cardinal) { Cardinals[ordinal.corner] }
    
    public var cardinals: (Cardinal, Cardinal) { Ordinal.cardinals(ordinal: self) }
    
    static func opposite(ordinal: Ordinal) -> Ordinal { Opposites[ordinal.corner] }
    
    public var opposite: Ordinal { Ordinal.opposite(ordinal: self) }
    
    static func ordinals(ordinal: Ordinal) -> (Ordinal, Ordinal) { Ordinals[ordinal.corner] }
    
    public var ordinals: (Ordinal, Ordinal) { Ordinal.ordinals(ordinal: self) }
    
    static func coordinate(ordinal: Ordinal) -> Coordinate { Coordinates[ordinal.corner] }
    
    public var coordinate: Coordinate { Ordinal.coordinate(ordinal: self) }
}
