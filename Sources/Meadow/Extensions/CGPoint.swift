//
//  CGPoint.swift
//
//  Created by Zack Brown on 03/11/2020.
//

import CoreGraphics

extension CGPoint: Hashable {
    
    init(vector: Vector) {
        
        self.init(x: vector.x, y: vector.y)
    }
    
    public func hash(into hasher: inout Hasher) {
        
        hasher.combine(x)
        hasher.combine(y)
    }
}

extension CGPoint {
    
    public static var one = CGPoint(x: 1, y: 1)
    
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
    
    static func == (lhs: CGPoint, rhs: CGPoint) -> Bool {
        
        return ((abs(lhs.x - rhs.x) < CGFloat(Math.epsilon)) && (abs(lhs.y - rhs.y) < CGFloat(Math.epsilon)))
    }
}

extension CGPoint {
    
    func lerp(point: CGPoint, interpolater: Double) -> CGPoint {
        
        return self + (point - self) * interpolater
    }
}
