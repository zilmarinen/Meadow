//
//  GridPattern.swift
//
//  Created by Zack Brown on 19/03/2021.
//

public struct GridPattern: Codable, Equatable {
    
    public var north: Bool
    public var east: Bool
    public var south: Bool
    public var west: Bool
    
    public var northWest: Bool
    public var northEast: Bool
    public var southEast: Bool
    public var southWest: Bool
    
    public init(value: Bool = true) {
        
        north = value
        east = value
        south = value
        west = value
        
        northWest = value
        northEast = value
        southEast = value
        southWest = value
    }
    
    public init(north: Bool = true,
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
}

extension GridPattern {
    
    func rule(for cardinal: Cardinal) -> GridPatternRule {
        
        switch cardinal {
        
        case .north: return GridPatternRule(left: northWest, center: north, right: northEast)
        case .east: return GridPatternRule(left: northEast, center: east, right: southEast)
        case .south: return GridPatternRule(left: southEast, center: south, right: southWest)
        case .west: return GridPatternRule(left: southWest, center: west, right: northWest)
        }
    }
}

extension GridPattern {
    
    static var defaults: [GridPattern] {
        
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
