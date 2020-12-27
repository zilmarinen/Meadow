//
//  Vector.swift
//
//  Created by Zack Brown on 03/11/2020.
//

import Foundation
import GLKit
import SceneKit

public struct Vector: Codable, Hashable {
    
    public var x: Double
    public var y: Double
    public var z: Double
    
    var description: String {
        
        return "[\(String(format: "%.2f", x)), \(String(format: "%.2f", y)), \(String(format: "%.2f", z))]"
    }
    
    public init(x: Double, y: Double, z: Double) {
        
        self.x = x
        self.y = y
        self.z = z
    }
    
    public init(coordinate: Coordinate) {
        
        self.init(x: Double(coordinate.x), y: Double(coordinate.y), z: Double(coordinate.z))
    }
    
    public init(vector: GLKVector3) {
        
        self.init(x: Double(vector.x), y: Double(vector.y), z: Double(vector.z))
    }
    
    public init(vector: SCNVector3) {
        
        self.init(x: Double(vector.x), y: Double(vector.y), z: Double(vector.z))
    }
}

public extension Vector {
    
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

public extension Vector {
    
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
    
    static func +=(lhs: inout Self, rhs: Self) {
        
        lhs = lhs + rhs
    }
    
    func isEqual(to vector: Vector) -> Bool {
        
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
    
    func angle(to plane: Plane) -> Double {
            
        let compliment = dot(vector: plane.normal) / magnitude
        
        return asin(compliment)
    }
    
    func distance(from plane: Plane) -> Double {
        
        return plane.normal.dot(vector: self) - plane.distance
    }
    
    func project(onto plane: Plane) -> Self {
        
        return self - plane.normal * distance(from: plane)
    }
    
    func compare(with plane: Plane) -> Plane.Comparison {
        
        let d = distance(from: plane)
        
        return (d < -Math.epsilon ? .back : (d > Math.epsilon ? .front : .coplanar))
    }
}

extension Vector: Transformable {
    
    public func translated(by translation: Self) -> Self {
        
        return self + translation
    }
    
    public func rotated(by rotation: Rotation) -> Self {
        
        let vector = GLKQuaternionRotateVector3(rotation.quaternion, GLKVector3(vector: self))
        
        return Vector(vector: vector)
    }
    
    public func scaled(by scale: Self) -> Self {
        
        return Vector(x: x * scale.x, y: y * scale.y, z: z * scale.z)
    }
    
    public func transformed(by transform: Transform) -> Self {
        
        return scaled(by: transform.scale).rotated(by: transform.rotation).translated(by: transform.position)
    }
}

extension Array where Element == Vector {
    
    func convex() -> Bool {
            
        guard count > 3, let first = first, let last = last else { return count > 2 }
        
        var ab = first - last
        
        var normal: Vector?
        
        for i in 0..<count {
            
            let v0 = self[i]
            let v1 = self[(i + 1) % count]
            
            let bc = v1 - v0
            
            var cross = ab.cross(vector: bc)
            
            let magnitude = cross.magnitude
            
            if magnitude > Math.epsilon {
                
                cross = cross / magnitude
                
                if let normal = normal {
                    
                    guard cross.dot(vector: normal) >= 0 else { return false }
                }
                
                normal = normal ?? cross
            }
            
            ab = bc
        }
        
        return true
    }
    
    func degenerate() -> Bool {
        
        guard let first = first, let last = last else { return false }
        
        var ab = first - last
        
        var magnitude = ab.magnitude
        
        guard magnitude > Math.epsilon else { return true }
        
        ab = ab / magnitude
        
        for i in 0..<count {
            
            let v0 = self[i]
            let v1 = self[(i + 1) % count]
            
            var bc = v1 - v0
            
            magnitude = bc.magnitude
            
            bc = bc / magnitude
            
            guard magnitude > Math.epsilon, abs(ab.dot(vector: bc) + 1) > Math.epsilon else { return true }
            
            ab = bc
        }
        
        return false
    }
    
    func clockwise() -> Bool {
        
        guard count > 2 else { return false }
        
        var sum = 0.0
        
        for i in 0..<count {
            
            let v0 = self[i]
            let v1 = self[(i + 1) % count]
            
            sum += (v1.x - v0.x) * (v1.y + v0.y)
        }
        
        return sum > 0
    }
    
    func normal() -> Vector {
        
        switch count {
            
        case 0, 1: return .z
            
        case 2:
            
            let ab = self.last! - self.first!
            
            return ab.cross(vector: .z).cross(vector: ab)
            
        default:
            
            var v0 = self.first!
            var v1: Vector?
            
            var ab = v0 - self.last!
            
            var magnitude = 0.0
            
            for vector in self {
                
                let bc = vector - v0
                
                let normal = ab.cross(vector: bc)
                
                let squaredMagnitude = normal.squaredMagnitude
                
                if squaredMagnitude > magnitude {
                    
                    magnitude = squaredMagnitude
                    
                    v1 = normal / squaredMagnitude.squareRoot()
                }
                
                v0 = vector
                ab = bc
            }
            
            return v1 ?? .z
        }
    }
}
