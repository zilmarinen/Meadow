//
//  Math.swift
//
//  Created by Zack Brown on 03/11/2020.
//

import Foundation
import GLKit

public enum Math {
    
    public static var epsilon = 1e-7
    public static var pi2 = .pi * 2.0
    
    public static func clamp(value: Int, minimum: Int, maximum: Int) -> Int {
        
        return min(max(value, minimum), maximum)
    }
    
    public static func quantize(value: Double) -> Double {
        
        return (value / epsilon).rounded() * epsilon
    }
    
    public static func radians(degrees: Double) -> Double {
        
        return Double(GLKMathDegreesToRadians(Float(degrees)))
    }
    
    public static func degrees(radians: Double) -> Double {
        
        return Double(GLKMathRadiansToDegrees(Float(radians)))
    }
}
