//
//  CGPoint.swift
//
//  Created by Zack Brown on 03/11/2020.
//

import Foundation

extension CGPoint: Hashable {
    
    public init(vector: Vector) {
        
        self.init(x: vector.x, y: vector.y)
    }
    
    public func hash(into hasher: inout Hasher) {
        
        hasher.combine(x)
        hasher.combine(y)
    }
}

public extension CGPoint {
    
    static var uvs: [CGPoint] { return [CGPoint(x: 0.0, y: 0.0), CGPoint(x: 1.0, y: 0.0), CGPoint(x: 1.0, y: 1.0), CGPoint(x: 0.0, y: 1.0), CGPoint(x: 0.5, y: 0.5)] }
}

extension CGPoint {
    
    static prefix func -(rhs: CGPoint) -> CGPoint {
        
        return CGPoint(x: -rhs.x, y: -rhs.y)
    }
    
    static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    static func *(lhs: CGPoint, rhs: Double) -> CGPoint {
        
        return CGPoint(x: lhs.x * CGFloat(rhs), y: lhs.y * CGFloat(rhs))
    }
    
    static func /(lhs: CGPoint, rhs: Double) -> CGPoint {
        
        return CGPoint(x: lhs.x / CGFloat(rhs), y: lhs.y / CGFloat(rhs))
    }
    
    func equal(to point: CGPoint) -> Bool {
        
        return self == point || ((abs(x - point.x) < CGFloat(Math.epsilon)) && (abs(y - point.y) < CGFloat(Math.epsilon)))
    }
}

extension CGPoint {
    
    func lerp(point: CGPoint, interpolater: Double) -> CGPoint {
        
        return self + (point - self) * interpolater
    }
}
