//
//  Cardinal.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Pasture
import SceneKit

public enum Cardinal: Int, CaseIterable, Codable {
    
    case north
    case east
    case south
    case west
    
    public var description: String {
        
        switch self {
            
        case .north: return "North"
        case .east: return "East"
        case .south: return "South"
        case .west: return "West"
        }
    }
}

extension Cardinal {
    
    private static var Cardinals: [(Cardinal, Cardinal)] = [
    
        (.east, .west),
        (.south, .north),
        (.west, .east),
        (.north, .south)
    ]
    
    private static var Opposites: [Cardinal] = [
    
        south,
        west,
        north,
        east
    ]
    
    private static var Ordinals: [(Ordinal, Ordinal)] = [
    
        (.northWest, .northEast),
        (.northEast, .southEast),
        (.southEast, .southWest),
        (.southWest, .northWest)
    ]
    
    private static var Normals: [Vector] = [
    
        .backward,
        .right,
        .forward,
        .left
    ]
    
    private static var NeighbourNormals: [[Cardinal : Vector]] = [
    
        [.east : Vector(x: 0.5, y: 0.0, z: 0.5), .west: Vector(x: -0.5, y: 0.0, z: 0.5)],
        [.south : Vector(x: -0.5, y: 0.0, z: 0.5), .north: Vector(x: -0.5, y: 0.0, z: -0.5)],
        [.west : Vector(x: -0.5, y: 0.0, z: -0.5), .east: Vector(x: 0.5, y: 0.0, z: -0.5)],
        [.north : Vector(x: 0.5, y: 0.0, z: -0.5), .south: Vector(x: 0.5, y: 0.0, z: 0.5)],
    ]
    
    public static func cardinals(cardinal: Cardinal) -> (Cardinal, Cardinal) {
        
        return Cardinals[cardinal.rawValue]
    }
    
    public var cardinals: (Cardinal, Cardinal) {
        
        return Cardinal.cardinals(cardinal: self)
    }
    
    public static func opposite(cardinal: Cardinal) -> Cardinal {
        
        return Opposites[cardinal.rawValue]
    }
    
    public var opposite: Cardinal {
        
        return Cardinal.opposite(cardinal: self)
    }
    
    public static func ordinals(cardinal: Cardinal) -> (Ordinal, Ordinal) {
        
        return Ordinals[cardinal.rawValue]
    }
    
    public var ordinals: (Ordinal, Ordinal) {
        
        return Cardinal.ordinals(cardinal: self)
    }
    
    public static func normal(cardinal: Cardinal) -> Vector {
        
        return Normals[cardinal.rawValue]
    }
    
    public var normal: Vector {
        
        return Cardinal.normal(cardinal: self)
    }
    
    public static func normal(cardinal: Cardinal, neighbour: Cardinal) -> Vector {
        
        return NeighbourNormals[cardinal.rawValue][neighbour]!
    }
    
    public func normal(neighbour: Cardinal) -> Vector {
        
        return Cardinal.normal(cardinal: self, neighbour: neighbour)
    }
    
    static func closest(vector: Vector) -> Cardinal {
        
        var match = Cardinal.north
        
        var smallestDistance = Double.infinity
        
        let x = Double(World.Axis.xz(value: vector.x))
        let z = Double(World.Axis.xz(value: vector.z))
        
        let centre = Vector(x: x, y: vector.y, z: z)
        
        Cardinal.allCases.forEach { cardinal in
            
            let (o0, o1) = cardinal.ordinals
            
            let c0 = centre + o0.vector
            let c1 = centre + o1.vector
            
            let edge = c0.lerp(vector: c1, interpolater: 0.5)
            
            let distance = (edge - vector).magnitude
            
            if distance < smallestDistance {
                
                match = cardinal
                
                smallestDistance = distance
            }
        }
        
        return match
    }
}
