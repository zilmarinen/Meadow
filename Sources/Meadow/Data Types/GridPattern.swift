//
//  GridPattern.swift
//
//  Created by Zack Brown on 09/11/2020.
//

public struct GridPattern: Codable, Equatable {
    
    public var north: Int?
    public var east: Int?
    public var south: Int?
    public var west: Int?
    
    public var northWest: Int?
    public var northEast: Int?
    public var southEast: Int?
    public var southWest: Int?
    
    public init(value: Int?) {
        
        north = value
        east = value
        south = value
        west = value
        
        northWest = value
        northEast = value
        southEast = value
        southWest = value
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
