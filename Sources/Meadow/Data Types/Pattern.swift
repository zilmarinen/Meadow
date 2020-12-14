//
//  Pattern.swift
//
//  Created by Zack Brown on 09/11/2020.
//

public struct Pattern: Codable, Equatable {
    
    var north: Int?
    var east: Int?
    var south: Int?
    var west: Int?
    
    var northWest: Int?
    var northEast: Int?
    var southEast: Int?
    var southWest: Int?
    
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

extension Pattern {
    
    func rule(for cardinal: Cardinal) -> PatternRule {
        
        switch cardinal {
        
        case .north: return PatternRule(left: northWest, center: north, right: northEast)
        case .east: return PatternRule(left: northEast, center: east, right: southEast)
        case .south: return PatternRule(left: southEast, center: south, right: southWest)
        case .west: return PatternRule(left: southWest, center: west, right: northWest)
        }
    }
}
