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
    
    init(id: Int) {
        
        self.init(value: false)
        
        var id = id
        
        for ordinal in Ordinal.allCases.reversed() {
         
            let value = 16 << ordinal.corner
            
            if id >= value {
                
                id -= value
                
                set(value: true, ordinal: ordinal)
            }
        }
        
        for cardinal in Cardinal.allCases.reversed() {
         
            let value = 1 << cardinal.edge
            
            if id >= value {
                
                id -= value
                
                set(value: true, cardinal: cardinal)
            }
        }
    }
    
    public var id: Int {
        
        var value = 0
        
        for cardinal in Cardinal.allCases {
            
            value |= self.value(for: cardinal) ? 1 << cardinal.edge : 0
        }
        
        for ordinal in Ordinal.allCases {
            
            value |= self.value(for: ordinal) ? 16 << ordinal.corner : 0
        }
        
        return value
    }
}
