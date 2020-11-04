//
//  Cardinal.swift
//
//  Created by Zack Brown on 03/11/2020.
//

enum Cardinal: Int, CaseIterable, Codable {
    
    case north
    case east
    case south
    case west
    
    var description: String {
            
        switch self {
            
        case .north: return "North"
        case .east: return "East"
        case .south: return "South"
        case .west: return "West"
        }
    }
}

extension Cardinal {
    
    private static var Coordinates: [Coordinate] { return [
    
        .backward,
        .right,
        .forward,
        .left
    ]}
    
    private static var Opposites: [Cardinal] = [
        
        south,
        west,
        north,
        east
    ]
    
    static func coordinate(cardinal: Cardinal) -> Coordinate {
        
        return Coordinates[cardinal.rawValue]
    }
    
    var coordinate: Coordinate {
        
        return Cardinal.coordinate(cardinal: self)
    }
    
    static func opposite(cardinal: Cardinal) -> Cardinal {
            
        return Opposites[cardinal.rawValue]
    }
    
    var opposite: Cardinal {
        
        return Cardinal.opposite(cardinal: self)
    }
}
