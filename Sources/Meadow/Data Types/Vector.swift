//
//  Vector.swift
//
//  Created by Zack Brown on 03/11/2020.
//

import Foundation
import GLKit
import SceneKit

struct Vector: Codable, Hashable {
    
    var x: Double
    var y: Double
    var z: Double
    
    var description: String {
        
        return "[\(x), \(y), \(z)]"
    }
    
    init(x: Double, y: Double, z: Double) {
        
        self.x = x
        self.y = y
        self.z = z
    }
    
    init(vector: GLKVector3) {
        
        self.init(x: Double(vector.x), y: Double(vector.y), z: Double(vector.z))
    }
    
    init(vector: SCNVector3) {
        
        self.init(x: Double(vector.x), y: Double(vector.y), z: Double(vector.z))
    }
}

extension Vector {
    
    static let x = Vector(x: 1, y: 0, z: 0)
    static let y = Vector(x: 0, y: 1, z: 0)
    static let z = Vector(x: 0, y: 0, z: 1)
    
    static let zero = Vector(x: 0, y: 0, z: 0)
    static let one = Vector(x: 1, y: 1, z: 1)
    static var left = -right
    static var right =  Vector(x: 1, y: 0, z: 0)
    static var forward = Vector(x: 0, y: 0, z: 1)
    static var backward = -forward
    static var up = Vector(x: 0, y: 1, z: 0)
    static var down = -up
    static var infinity = Vector(x: .infinity, y: .infinity, z: .infinity)
}

extension Vector {
    
    static prefix func -(rhs: Self) -> Self {
        
        return Vector(x: -rhs.x, y: -rhs.y, z: -rhs.z)
    }
    
    static func +(lhs: Self, rhs: Self) -> Self {
        
        return Vector(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }
    
    static func -(lhs: Self, rhs: Self) -> Self {
        
        return Vector(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
    }
    
    static func *(lhs: Self, rhs: Self) -> Self {
        
        return Vector(x: lhs.x * rhs.x, y: lhs.y * rhs.y, z: lhs.z * rhs.z)
    }
    
    static func *(lhs: Self, rhs: Double) -> Self {
        
        return Vector(x: lhs.x * rhs, y: lhs.y * rhs, z: lhs.z * rhs)
    }
    
    static func /(lhs: Self, rhs: Double) -> Self {
        
        return Vector(x: lhs.x / rhs, y: lhs.y / rhs, z: lhs.z / rhs)
    }
    
    func equal(to vector: Vector) -> Bool {
        
        return self == vector || ((abs(x - vector.x) < Math.epsilon) && (abs(y - vector.y) < Math.epsilon) && (abs(z - vector.z) < Math.epsilon))
    }
    
    static func minimum(lhs: Self, rhs: Self) -> Self {
        
        return Vector(x: min(lhs.x, rhs.x), y: min(lhs.y, rhs.y), z: min(lhs.z, rhs.z))
    }
    
    static func maximum(lhs: Self, rhs: Self) -> Self {
        
        return Vector(x: max(lhs.x, rhs.x), y: max(lhs.y, rhs.y), z: max(lhs.z, rhs.z))
    }
}

extension Vector {
    
    func cross(vector: Self) -> Self {
        
        return Vector(x: y * vector.z - z * vector.y, y: z * vector.x - x * vector.z, z: x * vector.y - y * vector.x)
    }
    
    func dot(vector: Self) -> Double {
        
        return x * vector.x + y * vector.y + z * vector.z
    }
    
    var magnitude: Double {
        
        return squaredMagnitude.squareRoot()
    }
    
    var squaredMagnitude: Double {
        
        return dot(vector: self)
    }
    
    var isNormalised: Bool {
        
        return abs(squaredMagnitude) < Math.epsilon
    }
    
    func normalised() -> Self {
        
        return self / magnitude
    }
    
    func quantized() -> Self {
        
        return Vector(x: Math.quantize(value: x), y: Math.quantize(value: y), z: Math.quantize(value: z))
    }
    
    func lerp(vector: Self, interpolater: Double) -> Self {
        
        return (self + (vector - self) * interpolater).quantized()
    }
    
    func angle(to vector: Self) -> Double {
        
        let cosine = (dot(vector: vector) / (magnitude * vector.magnitude))
        
        return acos(cosine)
    }
}
