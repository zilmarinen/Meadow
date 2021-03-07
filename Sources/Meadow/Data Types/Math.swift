//
//  Math.swift
//
//  Created by Zack Brown on 03/11/2020.
//

import Foundation
import GLKit

enum Math {
    
    static var epsilon = 1e-7
    static var pi2 = .pi * 2.0
    
    static func clamp(value: Int, minimum: Int, maximum: Int) -> Int {
        
        return min(max(value, minimum), maximum)
    }
    
    static func quantize(value: Double) -> Double {
        
        return (value / epsilon).rounded() * epsilon
    }
    
    static func radians(degrees: Double) -> Double {
        
        return Double(GLKMathDegreesToRadians(Float(degrees)))
    }
    
    static func degrees(radians: Double) -> Double {
        
        return Double(GLKMathRadiansToDegrees(Float(radians)))
    }
    
    static func plot(angle: Double, radius: Double) -> CGPoint {
        
        return CGPoint(x: CGFloat(cos(angle) * radius), y: CGFloat(sin(angle) * radius))
    }
}
