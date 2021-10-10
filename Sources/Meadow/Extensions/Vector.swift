//
//  Vector.swift
//
//  Created by Zack Brown on 03/11/2020.
//

import Euclid
import Foundation
import SceneKit

extension Vector {
    
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

public extension Vector {
    
    static var right =  Vector(x: 1, y: 0, z: 0)
    static var up = Vector(x: 0, y: 1, z: 0)
    static var forward = Vector(x: 0, y: 0, z: -1)
    static var infinity = Vector(x: .infinity, y: .infinity, z: .infinity)
}

public extension Vector {
    
    static func minimum(lhs: Self, rhs: Self) -> Self {

        return Vector(x: min(lhs.x, rhs.x), y: min(lhs.y, rhs.y), z: min(lhs.z, rhs.z))
    }

    static func maximum(lhs: Self, rhs: Self) -> Self {

        return Vector(x: max(lhs.x, rhs.x), y: max(lhs.y, rhs.y), z: max(lhs.z, rhs.z))
    }

    static func absolute(vector: Vector) -> Vector {

        return Vector(x: abs(vector.x), y: abs(vector.y), z: abs(vector.z))
    }
    
    func compare(with vector: Vector, precision: Double = Math.epsilon) -> Bool {
        
        return self == vector || (abs(x - vector.x) < precision && abs(y - vector.y) < precision && abs(z - vector.z) < precision)
    }
    
    func move(towards: Self, distance: Double) -> Self {
        
        let direction = (towards - self).normalized()
        
        let delta = min(distance, direction.length)
        
        return (self + (direction * delta)).quantized()
    }
}

extension Array where Element == Vector {
    
    func average() -> Vector {
        
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
        
        return Vector(x: x / Double(count), y: y / Double(count), z: z / Double(count))
    }
    
    public func normal() -> Vector {
        
        let z = Vector(x: 0, y: 0, z: 1)
        
        switch count {
            
        case 0, 1: return z
            
        case 2:
            
            let ab = self.last! - self.first!
            
            let normal = ab.cross(z).cross(ab)
            
            let length = normal.length
            
            guard length > 0 else { return Vector(1, 0, 0) }
            
            return normal / length
            
        default:
            
            var v0 = self.first!
            var v1: Vector?
            
            var ab = v0 - self.last!
            
            var magnitude = 0.0
            
            for vector in self {
                
                let bc = vector - v0
                
                let normal = ab.cross(bc)
                
                let squaredMagnitude = normal.lengthSquared
                
                if squaredMagnitude > magnitude {
                    
                    magnitude = squaredMagnitude
                    
                    v1 = normal / squaredMagnitude.squareRoot()
                }
                
                v0 = vector
                ab = bc
            }
            
            return v1 ?? z
        }
    }
}
