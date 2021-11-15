//
//  Position.swift
//
//  Created by Zack Brown on 03/11/2020.
//

import Euclid
import Foundation
import SceneKit

extension Position {
    
    public init(x: Double, y: Double, z: Double) {
        
        self.init(x, y, z)
    }
    
    public init(coordinate: Coordinate) {
        
        self.init(x: Double(coordinate.x), y: Double(coordinate.y), z: Double(coordinate.z))
    }
    
    public init(vector: SCNVector3) {
        
        self.init(x: Double(vector.x), y: Double(vector.y), z: Double(vector.z))
    }
}

public extension Position {
    
    static func minimum(lhs: Self, rhs: Self) -> Self {

        return Position(x: Swift.min(lhs.x, rhs.x), y: Swift.min(lhs.y, rhs.y), z: Swift.min(lhs.z, rhs.z))
    }

    static func maximum(lhs: Self, rhs: Self) -> Self {

        return Position(x: Swift.max(lhs.x, rhs.x), y: Swift.max(lhs.y, rhs.y), z: Swift.max(lhs.z, rhs.z))
    }

    static func absolute(vector: Vector) -> Position {

        return Position(x: abs(vector.x), y: abs(vector.y), z: abs(vector.z))
    }
    
    func compare(with vector: Position, precision: Double = Math.epsilon) -> Bool {
        
        return self == vector || (abs(x - vector.x) < precision && abs(y - vector.y) < precision && abs(z - vector.z) < precision)
    }
    
    func move(towards: Self, distance: Double) -> Self {
        
        let direction = (towards - self).direction
        
        let delta = Swift.min(distance, direction.norm)
        
        return (self + (direction * delta)).quantized()
    }
}

extension Array where Element == Position {
    
    func average() -> Direction {
        
        guard count > 0 else { return .zero }
        
        var x = 0.0
        var y = 0.0
        var z = 0.0
        
        for i in 0..<count {
            
            let vector = self[i]
            
            x += vector.x
            y += vector.y
            z += vector.z
        }
        
        return Direction(x: x / Double(count), y: y / Double(count), z: z / Double(count))
    }
    
    public func normal() -> Direction {
        
        let z = Direction(x: 0, y: 0, z: 1)
        
        switch count {
            
        case 0, 1: return z
            
        case 2:
            
            let ab = self.last! - self.first!
            
            let normal = ab.cross(z).cross(ab)
            
            let length = normal.norm
            
            guard length > 0 else { return Direction(1, 0, 0) }
            
            return (normal / length).direction
            
        default:
            
            var v0 = self.first!
            var v1: Distance?
            
            var ab = v0 - self.last!
            
            var magnitude = 0.0
            
            for vector in self {
                
                let bc = vector - v0
                
                let normal = ab.cross(bc)
                
                let squaredMagnitude = normal.norm
                
                if squaredMagnitude > magnitude {
                    
                    magnitude = squaredMagnitude
                    
                    v1 = normal / squaredMagnitude.squareRoot()
                }
                
                v0 = vector
                ab = bc
            }
            
            return v1?.direction ?? z
        }
    }
}
