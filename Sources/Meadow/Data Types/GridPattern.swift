//
//  GridPattern.swift
//
//  Created by Zack Brown on 19/03/2021.
//

public struct GridPattern<T: Codable & Equatable>: Codable, Equatable {
    
    public var north: T
    public var east: T
    public var south: T
    public var west: T
    
    public var northWest: T
    public var northEast: T
    public var southEast: T
    public var southWest: T
    
    public init(value: T) {
        
        north = value
        east = value
        south = value
        west = value
        
        northWest = value
        northEast = value
        southEast = value
        southWest = value
    }
    
    public init(north: T,
                east: T,
                south: T,
                west: T,
                northWest: T,
                northEast: T,
                southEast: T,
                southWest: T) {
        
        self.north = north
        self.east = east
        self.south = south
        self.west = west
        
        self.northWest = northWest
        self.northEast = northEast
        self.southEast = southEast
        self.southWest = southWest
    }
    
    public mutating func set(value: T, cardinal: Cardinal) {
        
        switch cardinal {
        
        case .north: north = value
        case .east: east = value
        case .south: south = value
        default: west = value
        }
    }
    
    public mutating func set(value: T, ordinal: Ordinal) {
        
        switch ordinal {
        
        case .northWest: northWest = value
        case .northEast: northEast = value
        case .southEast: southEast = value
        default: southWest = value
        }
    }
    
    public func value(for cardinal: Cardinal) -> T {
        
        switch cardinal {
        
        case .north: return north
        case .east: return east
        case .south: return south
        default: return west
        }
    }
    
    public func value(for ordinal: Ordinal) -> T {
        
        switch ordinal {
        
        case .northWest: return northWest
        case .northEast: return northEast
        case .southEast: return southEast
        default: return southWest
        }
    }
}

extension GridPattern {
    
    func rule(for cardinal: Cardinal) -> GridPatternRule<T> {
        
        switch cardinal {
        
        case .north: return GridPatternRule(left: northWest, center: north, right: northEast)
        case .east: return GridPatternRule(left: northEast, center: east, right: southEast)
        case .south: return GridPatternRule(left: southEast, center: south, right: southWest)
        default: return GridPatternRule(left: southWest, center: west, right: northWest)
        }
    }
}

extension GridPattern where T == Bool {
    
    init(north: Bool = true,
                east: Bool = true,
                south: Bool = true,
                west: Bool = true,
                northWest: Bool = true,
                northEast: Bool = true,
                southEast: Bool = true,
                southWest: Bool = true) {
        
        self.north = north
        self.east = east
        self.south = south
        self.west = west
        
        self.northWest = northWest
        self.northEast = northEast
        self.southEast = southEast
        self.southWest = southWest
    }
    
    public static func index(of pattern: GridPattern) -> Int {
        
        return defaults.firstIndex(of: pattern) ?? 0
    }
    
    public static var defaults: [GridPattern] {
        
        [GridPattern(value: true),
         GridPattern(northWest: false),
         GridPattern(northEast: false),
         GridPattern(southEast: false),
         GridPattern(southWest: false),//5
        
         GridPattern(northWest: false, northEast: false),
         GridPattern(northEast: false, southEast: false),
         GridPattern(southEast: false, southWest: false),
         GridPattern(northWest: false, southWest: false),
         GridPattern(northWest: false, southEast: false),
         GridPattern(northEast: false, southWest: false),//11
        
         GridPattern(northWest: false, northEast: false, southEast: false),
         GridPattern(northEast: false, southEast: false, southWest: false),
         GridPattern(northWest: false, southEast: false, southWest: false),
         GridPattern(northWest: false, northEast: false, southWest: false),
         GridPattern(northWest: false, northEast: false, southEast: false, southWest: false),//16
        
         GridPattern(north: false, northWest: false, northEast: false),
         GridPattern(east: false, northEast: false, southEast: false),
         GridPattern(south: false, southEast: false, southWest: false),
         GridPattern(west: false, northWest: false, southWest: false),
         GridPattern(north: false, south: false, northWest: false, northEast: false, southEast: false, southWest: false),
         GridPattern(east: false, west: false, northWest: false, northEast: false, southEast: false, southWest: false), //22
        
         GridPattern(north: false, northWest: false, northEast: false, southEast: false),
         GridPattern(north: false, northWest: false, northEast: false, southWest: false),
         GridPattern(north: false, northWest: false, northEast: false, southEast: false, southWest: false),//25
        
         GridPattern(east: false, northEast: false, southEast: false, southWest: false),
         GridPattern(east: false, northWest: false, northEast: false, southEast: false),
         GridPattern(east: false, northWest: false, northEast: false, southEast: false, southWest: false), //28
        
         GridPattern(south: false, northWest: false, southEast: false, southWest: false),
         GridPattern(south: false, northEast: false, southEast: false, southWest: false),
         GridPattern(south: false, northWest: false, northEast: false, southEast: false, southWest: false), //31
        
         GridPattern(west: false, northWest: false, northEast: false, southWest: false),
         GridPattern(west: false, northWest: false, southEast: false, southWest: false),
         GridPattern(west: false, northWest: false, northEast: false, southEast: false, southWest: false), //34
        
         GridPattern(north: false, west: false, northWest: false, northEast: false, southWest: false),
         GridPattern(north: false, west: false, northWest: false, northEast: false, southEast: false, southWest: false),//36
        
         GridPattern(north: false, east: false, northWest: false, northEast: false, southEast: false),
         GridPattern(north: false, east: false, northWest: false, northEast: false, southEast: false, southWest: false),//38
        
         GridPattern(east: false, south: false, northEast: false, southEast: false, southWest: false),
         GridPattern(east: false, south: false, northWest: false, northEast: false, southEast: false, southWest: false),//40
        
         GridPattern(south: false, west: false, northWest: false, southEast: false, southWest: false),
         GridPattern(south: false, west: false, northWest: false, northEast: false, southEast: false, southWest: false), //42
        
         GridPattern(north: false, east: false, west: false, northWest: false, northEast: false, southEast: false, southWest: false),
         GridPattern(north: false, east: false, south: false, northWest: false, northEast: false, southEast: false, southWest: false),
         GridPattern(east: false, south: false, west: false, northWest: false, northEast: false, southEast: false, southWest: false),
         GridPattern(north: false, south: false, west: false, northWest: false, northEast: false, southEast: false, southWest: false),
         GridPattern(value: false)//47
        ]
    }
}
